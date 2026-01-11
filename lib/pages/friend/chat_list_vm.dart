import 'dart:async';

import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/push_event_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

//聊天朋友列表VM
class ChatListViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  List<dynamic> chatList = [];
  bool loaded = false;
  StreamSubscription? _sub;

  ChatListViewModel(){
    _sub = FirebaseMessageManager.instance.stream.listen(onPush);
  }

  Future<void> init(UserProfileViewModel vm) async{
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
    }
  }

  //FCM处理
  void onPush(PushEventData msg) {
    final type = msg.message.data['type'];
    switch (type) {
      //收到私聊消息
      case 'privatemessage':
        load();
        break;
      //被邀请加入群聊
      case 'joingroup':
        load();
        break;
      //朋友更新自己的信息
      case 'friendinfochange':
        load();
        break;
      default:
        break;
    }
  }

  //加载数据
  Future<void> load() async {
    //加载聊天列表
    chatList = await Api.instance.getChatList();
    notifyListeners();
  }
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
