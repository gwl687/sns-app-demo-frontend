import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatDBManager.dart';
import 'package:demo10/manager/WebSocketManager.dart';
import 'package:demo10/pages/chat/videoChat_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final int friendId;
  final String friendName;
  String friendAvatarUrl;

  ChatPage({
    required this.friendId,
    required this.friendName,
    required this.friendAvatarUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  int myId = 0;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    //收到视频请求
    void videoRequest() async {
      // 弹出对话框
      final bool? accepted = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // 点空白处不能关闭，必须选一个
        builder: (ctx) => AlertDialog(
          title: Text("视频通话请求"),
          content: Text("对方想和你视频通话，是否接受？"),
          actions: [
            TextButton(
              child: Text("拒绝"),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            TextButton(
              child: Text("接受"),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      );
    }

    // 监听 WebSocket 消息(收消息，toUser一定是自己的id)
    WebSocketManager.instance.onPrivateMessage = (data) async {
      final String type = data['type'].toString();
      print("收到消息，type为${type}");
      switch (type) {
        case 'command':
          final String command = data['command'].toString();
          switch (command) {
            case "VIDEOREQUEST":
              // 弹出对话框
              final bool? accepted = await showDialog<bool>(
                context: context,
                barrierDismissible: false, // 点空白处不能关闭，必须选一个
                builder: (ctx) => AlertDialog(
                  title: Text("视频通话请求"),
                  content: Text("对方想和你视频通话，是否接受？"),
                  actions: [
                    TextButton(
                      child: Text("拒绝"),
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
                    TextButton(
                      child: Text("接受"),
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ],
                ),
              );
              if (accepted == true) {
                print("接收视频请求");
                // ✅ 用户点击了接受 → 通知对方
                WebSocketManager.instance.sendCommand(
                  data['fromUser'],
                  "VIDEO_CALL_ACCEPT",
                );
                // ✅ 跳转到视频页面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoChatPage(myId: myId, friendId: data['fromUser']),
                  ),
                );
              } else {
                print("拒绝视频请求");
                WebSocketManager.instance.sendCommand(
                  data['fromUser'],
                  "VIDEO_CALL_REJECT",
                );
              }
              break;
            case "VIDEO_CALL_ACCEPT":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoChatPage(myId: myId, friendId: data['fromUser']),
                ),
              );
              break;
            default:
          }
          break;
        //默认为聊天消息
        default:
          receivePrivateChatMessage(data);
      }
    };
  }

  void receivePrivateChatMessage(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final String content = data['content'].toString();
    final int toUser = await SpUtils.getString(Constants.SP_User_Id) ?? "";
    // 保存到本地数据库
    await ChatDbManager.insertMessage(fromUser, toUser, content);
    // 更新页面
    _loadMessages();
  }

  //重新加载消息
  Future<void> _loadMessages() async {
    myId = await SpUtils.getInt(Constants.SP_User_Id) ?? 0;
    final msgs = await ChatDbManager.getMessages(myId, widget.friendId);
    //final allmsgs = await ChatDbManager.selectAll();
    // for (var row in allmsgs) {
    //   print(
    //     "from: ${row['fromUser']}, to: ${row['toUser']}, content: ${row['content']}",
    //   );
    // }
    // print(
    //   "加载消息，刷新页面。我的id为${myId},对方为${widget.friendId},目前消息长度为${allmsgs.length}",
    // );
    setState(() {
      _messages = msgs;
    });
  }

  //发送消息
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

  //发起视频通话
  void _startVideoCall() {
    // 发起请求，发送特殊类型消息
    WebSocketManager.instance.sendCommand(
      widget.friendId,
      "VIDEOREQUEST", // 约定一个特殊消息标记
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("已向对方发起视频通话请求")));
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
          title: Text(widget.friendName),
          backgroundColor: Colors.green,
          actions: [
            IconButton(icon: Icon(Icons.videocam), onPressed: _startVideoCall),
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
      ),
    );
  }
}
