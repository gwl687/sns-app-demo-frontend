import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/chat/group_chat_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/group_chat_data.dart';
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
              int? ownerId = await SpUtils.getInt(BaseConstants.SP_User_Id);
              int _ownerId = ownerId ?? 0;
              //点击创建群组
              GroupChatData groupChatData = await Api.instance.createGroupChat(
                _selectedFriends,
              );
              await context.read<ChatListViewModel>().load();
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
      body: Consumer<FriendViewModel>(
        builder: (context, vm, child) {
          final friends = vm.friends;
          return ListView.separated(
            itemCount: friends.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = friends[index];
              final isSelected = _selectedFriends.contains(friend.userId);

              return ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedFriends.add(friend.userId);
                        _selectedFriendNames.add(friend.username);
                      } else {
                        _selectedFriends.remove(friend.userId);
                        _selectedFriendNames.remove(friend.username);
                      }
                    });
                  },
                ),
                title: Text(friend.username),
                subtitle: Text("ID: ${friend.userId}"),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(friend.avatarurl!),
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFriends.remove(friend.userId);
                    } else {
                      _selectedFriends.add(friend.userId);
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
