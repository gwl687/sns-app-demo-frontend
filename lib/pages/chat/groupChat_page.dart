import 'package:demo10/constants.dart';
import 'package:demo10/http/dio_instance.dart';
import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/ChatMessageManager.dart';
import 'package:demo10/manager/MessageReceiveManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/pages/chat/groupVideoChat_page.dart';
import 'package:demo10/pages/chat/videoChat_page.dart';
import 'package:demo10/pages/friend/addGroupMember_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/groupMessageData_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:demo10/pages/chat/videoChat_page.dart';

class GroupChatPage extends StatefulWidget {
  final int id;
  int ownerId;
  List<int> memberIds;
  String name;
  String avatarUrl;

  //final String friendName;

  GroupChatPage({
    required this.id,
    required this.ownerId,
    required this.memberIds,
    required this.name,
    required this.avatarUrl,
  });

  @override
  State createState() => _GroupChatPage();
}

class _GroupChatPage extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  int myId = -1;

  @override
  void initState() {
    super.initState();
    MessageReceiveManager.instance.chatPageGroupMessage = () {
      _loadMessages();
    };
    _loadMessages();
    //重置群名
  }

  @override
  void dispose() {
    MessageReceiveManager.instance.chatPagePrivateMessage = null;
    super.dispose();
  }

  //MessageReceiveManager.instance;

  //重新加载消息
  Future<void> _loadMessages() async {
    myId = await SpUtils.getInt(Constants.SP_User_Id) ?? 0;
    //final msgs = await ChatDbManager.getGroupMessages(widget.id);
    final msgs = ChatMessageManager.instance.groupMessages;
    setState(() {
      _messages = msgs;
    });
    //print("fromeuser=${msgs[msgs.length - 1]['fromUser']}myId=${myId}");
  }

  //发送群消息
  void _sendGroupMessage(String text) async {
    if (text.isEmpty) return;

    //发送消息到服务器
    WebSocketManager.instance.sendGroupMessage(widget.id, text);

    // 保存到本地数据库
    await ChatDbManager.insertGroupMessage(myId, widget.id, text);
    //保存到缓存

    // 重新加载消息
    _loadMessages();

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 阻止默认返回
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 跳转到主页(朋友聊天)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const TabPage(initialIndex: 2)),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupMember(
                      groupId: widget.id,
                      memberIds: widget.memberIds,
                      isAdd: true,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person_remove),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupMember(
                      groupId: widget.id,
                      memberIds: widget.memberIds,
                      isAdd: false,
                    ),
                  ),
                );
              },
            ),
            //vediochat
            IconButton(
              icon: Icon(Icons.camera_front),
              onPressed: () async {
                String token = await Api.instance.getLivekitToken(widget.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupVideoChatPage(token: token)
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = int.parse(msg['fromUser']) == myId;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.green[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg['content']),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "输入消息...",
                        border: InputBorder.none,
                      ),
                      //onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.green),
                    onPressed: () => _sendGroupMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
