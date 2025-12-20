import 'dart:async';

import 'package:demo10/manager/FirebaseMessageManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

//聊天朋友列表VM
class FriendChatListViewModel extends ChangeNotifier {
  List<dynamic> chatList = [];

  late final StreamSubscription _sub;

  FriendChatListViewModel() {
    _sub = FirebaseMessageManager.instance.stream.listen(_onMessage);
  }

  void _onMessage(RemoteMessage msg) {
    final type = msg.data['type'];
    if (type == 'joingroup') {
      load();
    }
  }

  //加载数据
  Future<void> load() async {
    chatList = await Api.instance.getChatList();
    print("chatlist长度为${chatList.length}");
    notifyListeners();
  }
  //清空数据
  Future<void> clear() async {
    chatList = await [];
    notifyListeners();
  }
}
