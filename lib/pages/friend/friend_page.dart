import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/repository/datas/friendlist_data.dart';
import 'package:flutter/material.dart';

import '../../repository/api.dart';
import '../chat/friendChatList_page.dart';

// 好友数据模型
// class Friend {
//   final String id;
//   final String userName;
//   final String avatarUrl;
//
//   Friend({
//     required this.id,
//     required this.userName,
//     required this.avatarUrl,
//   });
// }

class FriendPage extends StatefulWidget {
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Friend> friends = [
    Friend(
      id: '1',
      userName: 'Alice',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    Friend(
      id: '2',
      userName: 'Bob',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    Friend(
      id: '3',
      userName: 'Charlie',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    //FriendListManager.instance.loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('好友'), centerTitle: true),
      body: ValueListenableBuilder<List<Friend>>(
        valueListenable: FriendListManager.instance.friends,
        builder: (context, friends, _) {
          return ListView.separated(
            itemCount: friends.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.avatarUrl),
                ),
                title: Text(friend.userName),
                onTap: () {
                  // 点击可以跳转到 ChatPage 或其他页面
                  ChatFriendManager.addFriend(friend.id,friend.userName,friend.avatarUrl);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(friendId: friend.id, friendName: friend.userName)
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
