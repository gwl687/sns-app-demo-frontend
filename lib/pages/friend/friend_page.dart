import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
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
    return Consumer2<FriendViewModel, UserProfileViewModel>(
      builder: (context, friendVm, userProfileVm, child) {
        final myId = userProfileVm.userInfo!.userId;
        return Scaffold(
          appBar: AppBar(
            title: const Text('friends'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () async {
                  final int myId =
                      await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddfriendPage(myId: myId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.group_add),
                tooltip: 'create a group',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateGroupPage()),
                  );
                },
              ),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await friendVm.load();
            },
            child: ListView.separated(
              itemCount: friendVm.friends.length + 1,
              separatorBuilder: (context, index) => const Divider(height: 0.5),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildNewFriendsEntry(context);
                }

                final friend = friendVm.friends[index - 1];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend.avatarurl),
                  ),
                  title: Text(friend.username),
                  onTap: () async {
                    final privateChatData = PrivateChatData(
                      id: friend.userId,
                      userName: friend.username,
                      avatarUrl: friend.avatarurl,
                    );

                    final chatList = context.read<ChatListViewModel>().chatList;

                    final exists = chatList.any(
                      (e) => e is PrivateChatData && e.id == friend.userId,
                    );

                    if (!exists) {
                      chatList.insert(0, privateChatData);
                      Api.instance.addToChatList(friend.userId);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => ChatViewModel(
                            myId: myId,
                            friendId: friend.userId,
                            friendAvatarUrl: friend.avatarurl,
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
          ),
        );
      },
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
                child: NewFriendsPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
