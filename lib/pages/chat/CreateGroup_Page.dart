import 'dart:ffi';

import 'package:demo10/constants.dart';
import 'package:demo10/manager/ChatFriendManager.dart';
import 'package:demo10/manager/ChatListManager.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/chat/groupChat_page.dart';
import 'package:demo10/pages/friend/friendChatList_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  State createState() => _CreateGroupPage();
}

class _CreateGroupPage extends State<CreateGroupPage> {
  // 保存被选中的好友ID
  List<int> _selectedFriends = [];
  List<String> _selectedFriendNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create a chatgroup"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              int? ownerId = await SpUtils.getInt(Constants.SP_User_Id);
              int _ownerId = ownerId ?? 0;
              //点击创建群组
              GroupChatData groupChatData = await Api.instance.createGroupChat(
                _selectedFriends,
              );
              await context.read<FriendChatListViewModel>().load();
              print("群聊创建完成，选择的好友ID: $_selectedFriends");

              //这里可以传递选中的好友到下个页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupChatPage(
                    memberIds: _selectedFriends,
                    ownerId: groupChatData.ownerId,
                    id: groupChatData.groupId,
                    name: groupChatData.groupName,
                    avatarUrl: groupChatData.avatarUrl, //默认群头像
                  ),
                ),
              );
            },
            child: Text(
              "create",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Friend>>(
        valueListenable: FriendListManager.instance.friends,
        builder: (context, friends, _) {
          return ListView.separated(
            itemCount: friends.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = friends[index];
              final isSelected = _selectedFriends.contains(friend.id);

              return ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedFriends.add(friend.id);
                        _selectedFriendNames.add(friend.userName);
                      } else {
                        _selectedFriends.remove(friend.id);
                        _selectedFriendNames.remove(friend.userName);
                      }
                    });
                  },
                ),
                title: Text(friend.userName),
                subtitle: Text("ID: ${friend.id}"),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(friend.avatarUrl),
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFriends.remove(friend.id);
                    } else {
                      _selectedFriends.add(friend.id);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
