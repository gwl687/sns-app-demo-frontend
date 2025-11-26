import 'dart:io';

import 'package:demo10/constants.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/userInfo_data.dart';
import 'package:flutter/cupertino.dart';

class LoginSuccessManager{
  static final LoginSuccessManager instance = LoginSuccessManager._();
  LoginSuccessManager._();
  UserInfoData? userInfoData;
  ImageProvider? avatarImage;
  File? avatarFile;
  String? avatarFileUrl;

  Future<void> init() async{
    //获取用户信息
    userInfoData = await Api.instance.getUserInfo();
    avatarFileUrl = userInfoData?.avatarurl;
    //缓存头像
    avatarImage = avatarFile != null
        ? FileImage(avatarFile!) // 用户选择的本地图片
        : NetworkImage(
      '${avatarFileUrl ?? Constants.DefaultAvatarurl}?t=${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}