import 'package:demo10/constants.dart';
import 'package:demo10/repository/datas/auth_data.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../../repository/api.dart';

class AuthViewModel with ChangeNotifier {
  RegisterInfo registerInfo = RegisterInfo();
  LoginInfo loginInfo = LoginInfo();

  Future<bool?> register() async {
    if (registerInfo.name != null &&
        registerInfo.password != null &&
        registerInfo.rePassword != null &&
        registerInfo.password == registerInfo.rePassword) {
      if ((registerInfo.password?.length ?? 0) >= 6) {
        return await Api.instance.register(
          name: registerInfo.name,
          password: registerInfo.password,
          rePassword: registerInfo.rePassword,
        );
      }
      showToast("密码长度必须大于6位");
      return false;
    }
    showToast("输入不能为空或者密码必须一致");
    return false;
  }

  ///登录
  Future<bool?> login() async {
    if (loginInfo.name != null && loginInfo.password != null) {
      LoginData data = await Api.instance.login(
        emailaddress: loginInfo.name,
        password: loginInfo.password,
      );
      if (data.data?.userName != null && data.data?.userName?.isNotEmpty == true) {
        //保存用户名
        SpUtils.saveString(Constants.SP_User_Name, data.data?.userName??"");
        print("保存用户名${data.data?.userName}");
        return true;
      }
      showToast("登录失败");
      return false;
    }
    showToast("输入不能为空");
    return false;
  }

  void setLoginInfo({String? username, String? password}) {
    if (username != null) {
      loginInfo.name = username;
    }
    if (password != null) {
      loginInfo.password = password;
    }
  }
}

class RegisterInfo {
  String? name;
  String? password;
  String? rePassword;
}

class LoginInfo {
  String? name;
  String? password;
}
