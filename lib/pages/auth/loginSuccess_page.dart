import 'dart:io';
import 'dart:math';

import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/updateUserInfo_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoginSuccessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginSuccessPage();
}

class _LoginSuccessPage extends State<LoginSuccessPage> {
  File? _avatarFile; // 存储用户选择的头像文件
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录成功'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 头像
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarFile != null
                    ? FileImage(_avatarFile!) // 用户选择的本地图片
                    : NetworkImage(Constants.DefaultAvatarurl)
                          as ImageProvider, // 默认网络头像 // 头像图片链接，可换成本地或网络图
              ),
            ),
            SizedBox(height: 20),

            // 用户名
            Text(
              '用户名',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),

            // 退出按钮
            ElevatedButton(
              onPressed: () {
                //
                logout();
              },
              child: Text('退出登录'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 退出登录
  void logout() {
    //关闭websocket
    WebSocketManager.instance.close();
    //清空各种界面
    Chatlistmanager.instance.clearChatFriendList();
    FriendListManager.instance.clearFriendList();
    loginNotifier.value = 0;
  }

  /// 从相册选择图片
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
        UpdateUserInfo updateUserInfoDTO = UpdateUserInfo();
        Api.instance.updateUserInfo(updateUserInfoDTO);
      });
    }
  }
}
