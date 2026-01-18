import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/friend/newfriends_vm.dart';
import 'package:demo10/repository/datas/search_for_user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewFriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewFriendsPage();
}

class _NewFriendsPage extends State<NewFriendsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Friends'), centerTitle: true),
      //向我申请好友中的用户列表
      body: Consumer<NewFriendsViewModel>(
        builder: (context, vm, _) {
          if (vm.friendViewModel!.requestFriends.isEmpty) {
            return const Center(child: Text('No friend requests'));
          }
          return ListView.separated(
            itemCount: vm.friendViewModel!.requestFriends.length,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            itemBuilder: (context, index) {
              final requestFriend = vm.friendViewModel!.requestFriends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(requestFriend.avatarurl!),
                ),
                title: Text(requestFriend.username),
                trailing: _buildAction(vm.friendViewModel!, requestFriend),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAction(FriendViewModel vm, SearchForUserData user) {
    // 已同意
    if (user.status == 1) {
      return const Text('Accepted', style: TextStyle(color: Colors.green));
    }

    // 已拒绝
    if (user.status == 0) {
      return const Text('Rejected', style: TextStyle(color: Colors.grey));
    }

    // 正在申请（未处理）
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //同意
        TextButton(
          onPressed: () async {
            await vm.friendrequestresponse(user, 1);
          },
          child: const Text('Accept', style: TextStyle(color: Colors.green)),
        ),
        //拒绝
        TextButton(
          onPressed: () async {
            await vm.friendrequestresponse(user, 0);
          },
          child: const Text('Reject', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
