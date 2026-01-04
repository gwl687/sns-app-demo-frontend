import 'package:demo10/manager/chat_message_manager.dart';
import 'package:flutter/cupertino.dart';

class VideoChatViewModel extends ChangeNotifier {
  int status = -1;

  VideoChatViewModel() {
    ChatMessageManager.instance.videoChatCancel_vm = vedioChatcancel;
  }

  //对方挂断
  void vedioChatcancel() {
    //status = 0;
    //notifyListeners();
  }
}
