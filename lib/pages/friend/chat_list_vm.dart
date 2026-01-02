import 'dart:async';

import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

//聊天朋友列表VM
class ChatListViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  List<dynamic> chatList = [];
  bool loaded = false;

  void init(UserProfileViewModel vm) {
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
      ///加载聊天列表
      load();
    }
  }

  //FCM处理
  void onPush(RemoteMessage msg) {
    print("进入chatlistonpush");
    final type = msg.data['type'];
    if (type == 'privatemessage' || type == 'joingroup') {
      print("chatlistvm 收到消息 刷新");
      load();
    }
  }

  //加载数据
  Future<void> load() async {
    //加载聊天列表
    chatList = await Api.instance.getChatList();
    notifyListeners();
  }
}
