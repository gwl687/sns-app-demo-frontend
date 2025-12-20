import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/chat/groupChat_page.dart';
import 'package:demo10/pages/friend/friendChatList_vm.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 好友列表页面
class FriendChatList_page extends StatefulWidget {
  @override
  State createState() {
    return _FriendPage();
  }
}

class _FriendPage extends State<FriendChatList_page> {
  static List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void initData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CHAT"), backgroundColor: Colors.green),
      body: Consumer<FriendChatListViewModel>(
        builder: (context, vm, child) {
          final friendChatList = vm.chatList;
          return RefreshIndicator(
            onRefresh: () async {
              await vm.load();
            },
            child: ListView.builder(
              itemCount: friendChatList.length,
              itemBuilder: (context, index) {
                final friend = friendChatList[index];
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
                      child: Text(friend.groupName[0]), // 显示首字母
                    ),
                    title: Text(friend.groupName),
                    onTap: () {
                      //点击进入 ChatPage 或 GroupChatPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupChatPage(
                            id: friend.groupId,
                            ownerId: friend.ownerId,
                            memberIds: friend.memberIds,
                            name: friend.groupName,
                            avatarUrl: friend.avatarUrl,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
