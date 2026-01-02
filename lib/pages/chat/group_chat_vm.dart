import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';

class GroupChatViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> groupMessages = [];

  late int myId;

  UserInfoData userInfo;

  GroupChatViewModel(this.userInfo) {
    ChatMessageManager.instance.receiveGroupMessage_vm = (int groupId) {
      print("vm收到群聊消息");
      load(groupId);
    };
  }

  @override
  void dispose() {
    ChatMessageManager.instance.receiveGroupMessage_vm = null;
    super.dispose();
  }

  //加载群聊消息
  void load(int groupId) async {
    groupMessages = await ChatDbManager.getGroupMessages(groupId);
    myId = await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
    notifyListeners();
  }

  //发送群消息
  void sendGroupMessage(int userId, int groupId, String text) async {
    if (text.isEmpty) return;
    final message = {
      'fromUser': userId,
      'groupId': groupId,
      'content': text,
      'time': DateTime.now().toIso8601String(),
    };
    groupMessages.add(message);
    notifyListeners();
    //发送消息到服务器
    WebsocketManager.instance.sendMessage("group", groupId, text);
    //保存到本地数据库
    await ChatDbManager.insertGroupMessage(userId, groupId, text);
  }
}
