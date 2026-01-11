import 'package:demo10/app_config.dart';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/repository/datas/user/user_login_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';
import '../../repository/api.dart';

class AuthViewModel with ChangeNotifier {
  bool isLoggedIn = false;
  bool isLoggingIn = false;

  ///注册
  Future<void> register() async {}

  ///登录
  Future<void> login(LoginInfo loginInfo) async {
    isLoggingIn = true;
    notifyListeners();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? pushToken = await messaging.getToken();
    if (loginInfo.name != null && loginInfo.password != null) {
      UserLoginData data = await Api.instance.login(
        emailaddress: loginInfo.name,
        password: loginInfo.password,
        pushToken: pushToken!,
      );
      ///保存用户信息
      SpUtils.saveInt(BaseConstants.SP_User_Id, data.id ?? 0);
      SpUtils.saveString(BaseConstants.SP_Token, data.token ?? "");
      await initData();
      isLoggingIn = false;
      isLoggedIn = true;
      notifyListeners();
    } else {
      showToast("Input can not be empty");
    }
  }

  ///google登录
  Future<void> googleLogin() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? pushToken = await messaging.getToken();
    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: AppConfig.googleWebClientId,
    );
    await googleSignIn.signOut();
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final idTokenString = (await account!.authentication).idToken;
    isLoggingIn = true;
    notifyListeners();
    UserLoginData data = await Api.instance.googleLogin(
      idTokenString,
      pushToken,
    );
    ///保存用户信息
    SpUtils.saveInt(BaseConstants.SP_User_Id, data.id ?? 0);
    SpUtils.saveString(BaseConstants.SP_Token, data.token ?? "");
    await initData();
    isLoggingIn = false;
    isLoggedIn = true;
    notifyListeners();
  }

  ///登录成功后初始化各种数据
  initData() async {
    ///登录成功后建立 WebSocket 连接
    await WebsocketManager.instance.connect();

    ///增量读取离线时收到的消息，存入本地数据库
    await ChatMessageManager.instance.loadMessages();

    ///初始化FCM
    FirebaseMessageManager.instance.init();
  }

  ///登出后清理各种数据
  clearData() async {

  }

  ///登出
  logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
