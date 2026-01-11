import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> privateMessages = [];

  UserInfoData? userInfo;

  final int friendId;
  final int? myId;
  String friendName;
  String friendAvatarUrl;

  ChatViewModel({
    required this.myId,
    required this.friendId,
    required this.friendName,
    required this.friendAvatarUrl,
  }) {
    loadMessages(myId!, friendId);
    //聊天消息监听
    ChatMessageManager.instance.chatPagePrivateMessage_vm =
        (fromUser, toUser) async {
          await loadMessages(fromUser, toUser);
        };
  }

  @override
  void dispose() {
    ChatMessageManager.instance.chatPagePrivateMessage_vm = null;
    super.dispose();
  }

  //发送消息
  void sendMessage(String text) async {
    if (text.isEmpty) return;
    final privateMessage = {
      'fromUser': myId,
      'toUser': friendId,
      'content': text,
      'time': DateTime.now().toLocal().toIso8601String(),
    };
    privateMessages.add(privateMessage);
    notifyListeners();

    // 发送消息到服务器
    WebsocketManager.instance.sendMessage("private", friendId, text);

    // 保存到本地数据库
    await ChatDbManager.insertMessage(myId!, friendId, text);
  }

  //刷新私聊消息
  Future<void> loadMessages(int fromUser, int toUser) async {
    final raw = await ChatDbManager.getPrivateMessages(fromUser, toUser);
    privateMessages = raw.map<Map<String, dynamic>>((e) {
      return {
        'fromUser': int.parse(e['fromUser'].toString()),
        'toUser': int.parse(e['toUser'].toString()),
        'content': e['content'],
        'time': e['time'],
      };
    }).toList();
    notifyListeners();
  }

  //发起视频聊天
  void requestVideoCall() {
    WebsocketManager.instance.sendMessage(
      "videochatrequest",
      friendId,
      friendName,
    );
  }

  //收到视频聊天请求
  void onVideoChatRequest() {
    // videoChatRequest = true;
    notifyListeners();
  }
}
