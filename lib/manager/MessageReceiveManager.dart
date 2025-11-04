import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:demo10/utils/sp_utils.dart';

class MessageReceiveManager {
  static final MessageReceiveManager instance =
      MessageReceiveManager._instance();

  MessageReceiveManager._instance() {
    messageHandlers = {
      "private": privateMessage,
      "group": groupMessage,
      "joinGroupChat": joinGroupMessage,
    };
  }

  Map<String, Function(Map<String, dynamic>)> messageHandlers = {};

  //对应page的收消息方法

  //chatPage收到私聊消息
  void Function()? chatPagePrivateMessage = null;

  //chatPage收到群聊消息
  void Function()? chatPageGroupMessage = null;

  // void Function()  chatPagePrivateMessage(Map<String, dynamic> data) async {
  //   final int fromUser = data['fromUser'];
  //   final String content = data['content'];
  //   final int toUser = await SpUtils.getString(Constants.SP_User_Id) ?? "";
  //   //保存到本地数据库
  //   await ChatDbManager.insertMessage(fromUser, toUser, content);
  // }

  //全局receiveMessage方法
  //收到私聊消息
  void privateMessage(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final String content = data['content'];
    final int toUser = await SpUtils.getString(Constants.SP_User_Id) ?? "";
    //保存到本地数据库
    await ChatDbManager.insertMessage(fromUser, toUser, content);
    //当前页面为聊天页面,调用聊天页面的收消息方法
    if (chatPagePrivateMessage != null) {}
    print("收到群聊消息: $data");
  }

  //收到群聊消息
  void groupMessage(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final int toUser = data['toUser'];
    final String content = data['content'].toString();
    //保存到本地数据库
    await ChatDbManager.insertGroupMessage(fromUser, toUser, content);
    //当前页面为聊天页面,调用聊天页面的收消息方法
    if (chatPageGroupMessage != null) {
      chatPageGroupMessage!();
    }
    print("收到群聊消息: $data");
  }

  //这里收到的data里应该只需要groupid,然后直接从后端数据库查(之后在做本地数据库)
  void joinGroupMessage(Map<String, dynamic> data) async {
    print("收到加入群组消息: $data");
    //获取群id和名称
    int? _groupId = int.parse(
      data['type'].contains('_') ? data['type'].split('_')[1] : data['type'],
    );
    String _groupName = data['type'].contains('_')
        ? data['type'].split('_')[2]
        : data['type'];
    print("群名为${_groupName}");
    GroupChatData groupChat = await Api.instance.getGroupChat(_groupId);
    Chatlistmanager.instance.addGroup(groupChat);
  }
}
