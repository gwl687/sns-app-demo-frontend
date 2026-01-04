import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/create_group_page.dart';
import 'package:demo10/pages/friend/add_friend_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/friend/newfriends_page.dart';
import 'package:demo10/pages/friend/newfriends_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/private_chat_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            onPressed: () async {
              //点击跳转到加好友页面
              final int myId =
                  await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddfriendPage(myId: myId)),
              );
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.group_add),
          //   tooltip: 'create a group',
          //   onPressed: () {
          //     // 点击跳转到建群页面
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => CreateGroupPage()),
          //     );
          //   },
          // ),
        ],
      ),
      //朋友列表
      body: Consumer<FriendViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.load();
            },
            child: ListView.separated(
              itemCount: vm.friends.length + 1,
              separatorBuilder: (context, index) => Divider(height: 0.5),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildNewFriendsEntry(context);
                }
                final friend = vm.friends[index - 1];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend.avatarurl!),
                  ),
                  title: Text(friend.username),
                  onTap: () async {
                    final myId = await SpUtils.getInt(BaseConstants.SP_User_Id);
                    PrivateChatData privateChatData = PrivateChatData(
                      id: friend.userId,
                      userName: friend.username,
                      avatarUrl: friend.avatarurl!,
                    );
                    final chatList = context.read<ChatListViewModel>().chatList;
                    final exists = chatList.any(
                      (e) => e is PrivateChatData && e.id == friend.userId,
                    );
                    //如果聊天列表里没有，添加到聊天列表
                    if (!exists) {
                      chatList.insert(0, privateChatData);
                      Api.instance.addToChatList(friend.userId);
                    }
                    //点击跳转到ChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => ChatViewModel(
                            myId: vm.userProfileVm!.userInfo!.userId,
                            friendId: friend.userId,
                            friendAvatarUrl: friend.avatarurl!,
                            friendName: friend.username,
                          ),
                          child: ChatPage(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  //新好友的页面
  Widget _buildNewFriendsEntry(BuildContext context) {
    return Container(
      color: Colors.blue.withAlpha(20), // 与好友行区分
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person_add_alt_1, color: Colors.white),
        ),
        title: Text(
          'New Friends',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        subtitle: Text('Friend requests', style: TextStyle(fontSize: 12)),
        trailing: Icon(Icons.chevron_right, color: Colors.blue),
        onTap: () {
          final friendVm = context.read<FriendViewModel>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => NewFriendsViewModel(friendVm),
                child:  NewFriendsPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
