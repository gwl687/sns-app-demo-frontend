import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:flutter/material.dart';


// 好友列表页面
class FriendChatList_page extends StatefulWidget {
  @override
  State createState() {
    return _FriendPage();
  }
}

class _FriendPage extends State<FriendChatList_page> {
  final List<String> _friends = [
    "张三",
    "李四",
    "王五",
    "赵六",
    "小明",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("聊天"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(friend[0]), // 显示首字母
            ),
            title: Text(friend),
            onTap: () {
              // 点击进入 ChatPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(friendName: friend),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
