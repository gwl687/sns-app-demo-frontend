import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogManager {
  static final DialogManager instance = DialogManager._();

  DialogManager._();

  bool _videoInviteShowing = false;

  BuildContext? _dialogContext;

  Future<void> showVideoInviteDialog({
    required BuildContext context,
    required int fromUserId,
    required String fromUserName,
  }) async {
    // 防止重复弹窗
    if (_videoInviteShowing) return;
    _videoInviteShowing = true;

    final bool? accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        _dialogContext = ctx;
        return AlertDialog(
          title: const Text("video chat invite"),
          content: Text("${fromUserName} is inviting you to a video chat"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text("Reject"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );

    _videoInviteShowing = false;

    if (accepted == true) {
      // 通知对方：接受
      WebsocketManager.instance.sendMessage(
        "videochatrequestresponse",
        fromUserId,
        "1",
      );
      String token = await Api.instance.getLivekitToken(fromUserId);
      // 跳转到视频页面
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => VideoChatPage(token: token)));
    } else {
      // 通知对方：拒绝
      WebsocketManager.instance.sendMessage(
        "videochatrequestresponse",
        fromUserId,
        "0",
      );
    }
  }
  //关弹窗
  void dismissVideoInvite() {
    if (_videoInviteShowing && _dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
      _videoInviteShowing = false;
    }
  }
}
