import 'dart:io';

import 'package:demo10/constants.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class LoginInfo {
  String? name;
  String? password;
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginInfo loginInfo = LoginInfo();
  WebSocket? _socket;

  /// 登录方法（你说的已经写好，这里直接放进来）
  Future<bool?> login() async {
    if (loginInfo.name != null && loginInfo.password != null) {
      //调你的接口
      LoginData data = await Api.instance.login(
        emailaddress: loginInfo.name,
        password: loginInfo.password,
      );
      if (data.data?.userName != null &&
          data.data?.userName?.isNotEmpty == true) {
        //保存用户信息
        SpUtils.saveString(Constants.SP_User_Id, data.data?.id.toString()??"");
        SpUtils.saveString(Constants.SP_User_Name, data.data?.userName??"");
        SpUtils.saveString(Constants.SP_Token, data.data?.token??"");
        print("保存用户名: ${data.data?.userName}");
        print("保存token: ${data.data?.token}");
        // 登录成功后建立 WebSocket 连接
        await WebSocketManager.instance.connect();
        return true;
      }
      showToast("登录失败");
      return false;
    }
    showToast("输入不能为空");
    return false;
  }

  /// 建立 WebSocket 连接
  Future<void> _connectSocket() async {
    try {
      _socket = await WebSocket.connect('ws://10.0.2.2:8081/ws'); // 模拟器访问本地
      _socket!.listen(
        (message) {
          print("收到消息: $message");
        },
        onDone: () {
          print("WebSocket 关闭");
        },
        onError: (error) {
          print("WebSocket 错误: $error");
        },
      );
      print("WebSocket 已连接到 Netty 8081");
    } catch (e) {
      print("连接失败: $e");
    }
  }

  @override
  void dispose() {
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 用户名输入
            TextField(
              decoration: const InputDecoration(
                labelText: "用户名",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                loginInfo.name = value;
              },
            ),
            const SizedBox(height: 16),

            /// 密码输入
            TextField(
              decoration: const InputDecoration(
                labelText: "密码",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) {
                loginInfo.password = value;
              },
            ),
            const SizedBox(height: 32),

            /// 登录按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool? success = await login();
                  if (success == true) {
                    showToast("登录成功");
                    //Navigator.pop(context); // 登录成功后返回上一个页面
                  }
                },
                child: const Text("登录"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
