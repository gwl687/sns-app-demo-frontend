import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class TabViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  int loginPage = 0;
  bool loaded = false;

  void init(UserProfileViewModel vm) {
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
    }
  }


  ///监听firebase消息
  void onPush(RemoteMessage msg) {
    final type = msg.data['type'];
    if (type == 'friendRequestResponse') {}
  }

  TabViewModel() {
    ///视频通话请求监听
    ChatMessageManager.instance.vedioChatRequest_vm = handleVideoInvite;
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
}
