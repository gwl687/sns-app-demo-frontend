import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String friendId;
  final String friendName;

  ChatPage({required this.friendId, required this.friendName});

  @override
  State createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  String myId = "";

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // 监听 WebSocket 消息(收消息，toUser一定是自己的id)
    WebSocketManager.instance.onMessageReceived = (data) async {
      // 假设后端发来的 JSON 结构是：
      // {"fromUser":"123","toUser":"456","content":"hello"}
      final String fromUser = data['userId'].toString();
      final String content = data['content'].toString();
      final String toUser = await SpUtils.getString(Constants.SP_User_Id)??"";
      // 保存到本地数据库
      await ChatDbManager.insertMessage(fromUser, toUser, content);
      // 更新页面
      _loadMessages();
    };
  }

  Future<void> _loadMessages() async {
    myId = await SpUtils.getString(Constants.SP_User_Id);
    final msgs = await ChatDbManager.getMessages(myId, widget.friendId);
    setState(() {
      _messages = msgs;
    });
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    // 发送消息到服务器
    WebSocketManager.instance.sendMessage(widget.friendId, text);

    // 保存到本地数据库
    await ChatDbManager.insertMessage(myId, widget.friendId, text);

    // 重新加载消息
    _loadMessages();

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['fromUser'] == myId;

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
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
