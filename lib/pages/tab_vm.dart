import 'dart:async';

import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/dialog_manager.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/datas/push_event_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  int loginPage = 0;
  bool loaded = false;
  StreamSubscription? _sub;
  int? pendingChatUserId;

  TabViewModel() {
    ///视频通话请求监听
    ChatMessageManager.instance.vedioChatRequest_vm = handleVideoInvite;

    ///视频通话请求取消监听
    ChatMessageManager.instance.vedioChatRequestCancel_vm =
        vedioChatRequestCancel;

    _sub = FirebaseMessageManager.instance.stream.listen(onPush);
  }

  void init(UserProfileViewModel vm) {
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
    }
  }

  ///监听firebase消息
  void onPush(PushEventData msg) {
    final type = msg.message.data['type'];
    switch (type) {
      case "privatemessage":
        pendingChatUserId = int.parse(msg.message.data['fromUser']);
        print("pendingChatUserId=${pendingChatUserId}");
        notifyListeners();
        break;
      default:
        break;
    }
  }

  void consumePendingChat() {
    pendingChatUserId = null;
  }

  /// 视频弹窗
  Future<void> Function({
    required int fromUserId,
    required String fromUserName,
  })?
  onVideoInvite;

  ///监听websocket消息
  ///收到视频通话请求
  void handleVideoInvite(int fromUserId, String fromUserName) {
    if (onVideoInvite != null) {
      onVideoInvite!(fromUserId: fromUserId, fromUserName: fromUserName);
    }
  }

  ///收到视频通话请求取消
  void vedioChatRequestCancel() {
    DialogManager.instance.dismissVideoInvite();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
