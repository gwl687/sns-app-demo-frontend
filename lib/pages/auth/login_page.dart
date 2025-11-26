import 'dart:io';
import 'package:demo10/app.dart';
import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/ChatMessageManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/manager/LoginSuccessManager.dart';
import 'package:demo10/manager/TabPageManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/pages/auth/loginSuccess_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:demo10/pages/tab_page.dart';

final ValueNotifier<int> loginNotifier = ValueNotifier<int>(0);

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

  final TextEditingController _passwordController = TextEditingController(
    text: "123456", // 默认密码
  );
  final TextEditingController _usernameController = TextEditingController();

  List<String> _historyAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadHistoryAccounts(); // ✅ 初始化时加载历史账号
  }

  /// 加载历史账号
  Future<void> _loadHistoryAccounts() async {
    List<String>? list = await SpUtils.getStringList("login_history");
    setState(() {
      _historyAccounts = list ?? [];
    });
  }

  /// 保存账号到历史记录
  Future<void> _saveAccount(String account) async {
    List<String>? list = await SpUtils.getStringList("login_history") ?? [];
    if (!list.contains(account)) {
      list.insert(0, account); // 最新账号放前面
      await SpUtils.saveStringList("login_history", list);
    }
  }

  /// 登录方法
  Future<bool?> login() async {
    if (loginInfo.name != null && loginInfo.password != null) {
      // 调你的接口
      LoginData data = await Api.instance.login(
        emailaddress: loginInfo.name,
        password: loginInfo.password,
      );

      if (data.data?.userName != null && data.data!.userName!.isNotEmpty) {
        // 保存用户信息
        SpUtils.saveInt(Constants.SP_User_Id, data.data?.id ?? 0);
        SpUtils.saveString(Constants.SP_User_Name, data.data?.userName ?? "");
        SpUtils.saveString(Constants.SP_Token, data.data?.token ?? "");

        //登录成功后建立 WebSocket 连接
        await WebSocketManager.instance.connect();
        //load friend list
        await FriendListManager.instance.loadFriends();
        //load chatFriend list
        await Chatlistmanager.instance.loadFriends();
        //load loginsuccesspage data
        //await
        //加载离线时收到的消息
        await ChatMessageManager.instance.loadMessages();
        return true;
      }

      showToast("登录失败");
      return false;
    }

    showToast("输入不能为空");
    return false;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 用户名输入框
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "用户名",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                loginInfo.name = value;
              },
            ),

            /// 历史账号列表（只在有历史时显示）
            if (_historyAccounts.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "历史账号",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 120, // 最多显示的高度
                child: ListView.builder(
                  itemCount: _historyAccounts.length,
                  itemBuilder: (context, index) {
                    final account = _historyAccounts[index];
                    return ListTile(
                      title: Text(account),
                      onTap: () {
                        _usernameController.text = account;
                        loginInfo.name = account;
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 16),

            /// 密码输入框
            TextField(
              controller: _passwordController,
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
                  loginInfo.password = _passwordController.text;
                  bool? success = await login();
                  if (success == true) {
                    _saveAccount(_usernameController.text);
                  //print("保存账号${_usernameController.text}");
                  //showToast("登录成功");
                    //跳转到登录成功页
                    await LoginSuccessManager.instance.init();
                    TabPageManager.loginNotifier.value = 1;
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
