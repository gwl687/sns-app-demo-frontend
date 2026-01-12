import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';

class GroupChatViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> groupMessages = [];
  int id;
  int ownerId;
  List<int> memberIds;
  String name;
  String avatarUrl;
  Map<int, UserInfoData> memberMap = {};

  GroupChatViewModel({
    required this.id,
    required this.ownerId,
    required this.memberIds,
    required this.name,
    required this.avatarUrl,
  }) {
    ChatMessageManager.instance.receiveGroupMessage_vm = (int groupId) {
      print("vm收到群聊消息");
      loadMessages();
    };
  }

  @override
  void dispose() {
    ChatMessageManager.instance.receiveGroupMessage_vm = null;
    super.dispose();
  }

  ///加载群成员信息
  Future<void> loadMemberInfos() async {
    for (int memberId in memberIds) {
      memberMap[memberId] = await Api.instance.getUserInfoById(memberId);
    }
  }

  ///加载群聊消息
  Future<void> loadMessages() async {
    final raw = await ChatDbManager.getGroupMessages(id);
    groupMessages = raw.map<Map<String, dynamic>>((e) {
      return {
        'fromUser': int.parse(e['fromUser'].toString()),
        'groupId': int.parse(e['groupId'].toString()),
        'content': e['content'],
        'time': e['time'],
      };
    }).toList();
    notifyListeners();
  }

  ///发送群消息
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

    ///发送消息到服务器
    WebsocketManager.instance.sendMessage("group", groupId, text);

    ///保存到本地数据库
    await ChatDbManager.insertGroupMessage(userId, groupId, text);
  }
}
