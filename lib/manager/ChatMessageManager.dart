import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:demo10/repository/datas/groupMessage_data.dart';

class ChatMessageManager {
  static final ChatMessageManager instance = ChatMessageManager._();

  ChatMessageManager._();

  List<Map<String, dynamic>> groupMessages = [];

  //加载后端数据
  Future<void> loadMessages() async {
    //群
    Chatlistmanager.instance.chatList.value.forEach((chatListMember) async {
      if (chatListMember is GroupChatData) {
        SaveGroupMessagesIntoDartDb(chatListMember.groupId);
      } else {
        //好友
      }
    });
  }

  //save groupmessages into dart db
  void SaveGroupMessagesIntoDartDb(int groupId) async {
    //拿后端mysql数据
    GroupMessageData groupMessageData = await Api.instance.getGroupMessages(
      groupId,
    );
    if (groupMessageData.data.length != 0) {
      groupMessageData.data.forEach((groupMessage) async {
        int? latestId = await ChatDbManager.getGroupMessageLatestId(groupId);
        //只插入比本地数据库新的数据
        if (latestId == null || groupMessage.id > latestId) {
          print("保存后端数据到本地数据库");
          ChatDbManager.insertGroupMessage(
            groupMessage.senderId,
            groupMessage.groupId,
            groupMessage.content,
          );
        }
      });
    }
  }
}
