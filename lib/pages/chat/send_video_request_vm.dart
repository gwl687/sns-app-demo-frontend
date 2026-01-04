import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:flutter/cupertino.dart';

class SendVideoRequestViewModel extends ChangeNotifier {
  final int friendId;
  int status = -1;

  SendVideoRequestViewModel({required this.friendId}) {
    ChatMessageManager.instance.vedioChatRequestReponse_vm =
        vedioChatRequestReponse;
  }

  //对方回复（accept = 1 接受，0 拒绝）
  void vedioChatRequestReponse(int fromUser, int accept) {
    status = accept;
    notifyListeners();
  }

  //取消视频通话
  void cancel() {
    WebsocketManager.instance.sendMessage(
      "videochatrequestcancel",
      friendId,
      "",
    );
  }
}
