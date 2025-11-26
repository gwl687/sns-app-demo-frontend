import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/chat/groupChat_page.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:flutter/material.dart';

// 好友列表页面
class FriendChatList_page extends StatefulWidget {
  @override
  State createState() {
    return _FriendPage();
  }

  // static void addFriend(String friendName) {
  //   _FriendPage.addFriend(friendName);
  // }
}

class _FriendPage extends State<FriendChatList_page> {
  static List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  void initData(){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("聊天"), backgroundColor: Colors.green),
      body: ValueListenableBuilder<List<dynamic>>(
        valueListenable: Chatlistmanager.instance.chatList,
        builder: (context, friends, _) {
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              if (friend is Friend) {
                //是好友
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(friend.userName[0]), // 显示首字母
                  ),
                  title: Text(friend.userName),
                  onTap: () {
                    //点击进入 ChatPage 或 GroupChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          friendId: friend.id,
                          friendName: friend.userName,
                          friendAvatarUrl: "https://i.pravatar.cc/150?img=1",
                        ),
                      ),
                    );
                  },
                );
              } else if (friend is GroupChatData) {
                //是群聊
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(friend.data.groupName[0]), // 显示首字母
                  ),
                  title: Text(friend.data.groupName),
                  onTap: () {
                    //点击进入 ChatPage 或 GroupChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatPage(
                          id: friend.data.groupId,
                          ownerId: friend.data.ownerId,
                          memberIds: friend.data.memberIds,
                          name: friend.data.groupName,
                          avatarUrl: friend.data.avatarUrl,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
