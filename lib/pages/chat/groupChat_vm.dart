import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/MessageReceiveManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';

class GroupChatViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> groupMessages = [];

  int myId = -1;

  GroupChatViewModel() {
    MessageReceiveManager.instance.receiveGroupMessage = (int groupId) {
      print("vm收到群聊消息");
      load(groupId);
    };
  }

  //加载群聊消息
  void load(int groupId) async {
    groupMessages = await ChatDbManager.getGroupMessages(groupId);
    myId = await SpUtils.getInt(Constants.SP_User_Id) ?? 0;
    notifyListeners();
  }

  //发送群消息
  void sendGroupMessage(int userId, int groupId, String text) async {
    if (text.isEmpty) return;

    //发送消息到服务器
    WebSocketManager.instance.sendGroupMessage(groupId, text);

    //保存到本地数据库
    await ChatDbManager.insertGroupMessage(userId, groupId, text);

    groupMessages = await ChatDbManager.getGroupMessages(groupId);

    notifyListeners();
  }
}
