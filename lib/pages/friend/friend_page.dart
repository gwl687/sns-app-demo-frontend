import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/chat/CreateGroup_Page.dart';
import 'package:demo10/pages/friend/addFriend_page.dart';
import 'package:demo10/repository/datas/friendlist_data.dart';
import 'package:flutter/material.dart';
import '../../repository/api.dart';
import 'friendChatList_page.dart';
import 'package:demo10/manager/ChatListManager.dart';

class FriendPage extends StatefulWidget {
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('friends'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            tooltip: 'add a new friend',
            onPressed: () {
              //点击跳转到加好友页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddfriendPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.group_add),
            tooltip: 'create a group',
            onPressed: () {
              // 点击跳转到建群页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateGroupPage()),
              );
            },
          ),
        ],
      ),
      //朋友列表
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
                  //点击可以跳转到 ChatPage 或其他页面
                  Chatlistmanager.instance.addFriend(
                    friend.id,
                    friend.userName,
                    friend.avatarUrl,
                  );
                  Chatlistmanager.instance.chatIdList.value.add(friend.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        friendId: friend.id,
                        friendName: friend.userName,
                        friendAvatarUrl: Constants.DefaultAvatarurl,
                      ),
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
