import 'dart:io';
import 'dart:math';

import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/manager/LoginSuccessManager.dart';
import 'package:demo10/manager/TabPageManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/friend/friendChatList_vm.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/updateUserInfo_data.dart';
import 'package:demo10/repository/datas/user/userInfo_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:demo10/manager/FirebaseMessageManager.dart';
import 'package:provider/provider.dart';

class LoginSuccessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginSuccessPage();
}

class _LoginSuccessPage extends State<LoginSuccessPage> {
  static final _LoginSuccessPage loginSuceessPage = _LoginSuccessPage();
  File? _avatarFile; // 存储用户选择的头像文件
  String? _avatarFileUrl;
  String? _username;
  final ImagePicker _picker = ImagePicker();
  UserInfoData? userInfoData;
  ImageProvider? _avatarImage;

  @override
  void initState() {
    super.initState();
  }

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
                backgroundImage: LoginSuccessManager.instance.avatarImage,
              ),
            ),
            SizedBox(height: 20),

            // 用户名
            Text(
              LoginSuccessManager.instance.userInfoData?.username ?? "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),

            // 退出按钮
            ElevatedButton(
              onPressed: () {
                context.read<FriendChatListViewModel>().clear();
                context.read<TimelineViewModel>().clear();
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
    //聊天页面
    Chatlistmanager.instance.clearChatFriendList();
    //朋友页面
    FriendListManager.instance.clearFriendList();
    //我的页面
    _clearLoginSuccess();
    TabPageManager.loginNotifier.value = 0;
    FirebaseMessageManager.instance.loggedIn = false;
  }

  /// 从相册选择图片
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        LoginSuccessManager.instance.avatarFile = File(pickedFile.path);
        LoginSuccessManager.instance.avatarImage = FileImage(
          LoginSuccessManager.instance.avatarFile!,
        );
        //upload to s3
        uploadToS3(pickedFile.path);
        //update mysql user table
        //UpdateUserInfo updateUserInfoDTO = UpdateUserInfo();
        //Api.instance.updateUserInfo(updateUserInfoDTO);
      });
    }
  }

  /// 上传到s3
  Future<void> uploadToS3(String filePath) async {
    final fileName = basename(filePath);
    await Api.instance.uploadAvatar(filePath, fileName);
  }

  ///清空页面数据
  void _clearLoginSuccess() {
    print("清空我的页面数据");
    userInfoData = null;
    _avatarFile = null;
  }
}
