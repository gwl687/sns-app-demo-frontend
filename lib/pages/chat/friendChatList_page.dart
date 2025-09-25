import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:flutter/material.dart';

// 好友列表页面
class FriendChatList_page extends StatefulWidget {
  @override
  State createState() {
    return _FriendPage();
  }

  static void addFriend(String friendName) {
    _FriendPage.addFriend(friendName);
  }
}

class _FriendPage extends State<FriendChatList_page> {
  static List<String> _friends = [];

  static void addFriend(String friendName) {
    if (!_friends.contains(friendName)) {
      _friends.add(friendName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("聊天"), backgroundColor: Colors.green),
      body: ValueListenableBuilder<List<Friend>>(
        valueListenable: FriendListManager.instance.friends,
        builder: (context, friends, _) {
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(friend.userName[0]), // 显示首字母
                ),
                title: Text(friend.userName),
                onTap: () {
                  // 点击进入 ChatPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(friendId: friend.id, friendName: friend.userName)
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
