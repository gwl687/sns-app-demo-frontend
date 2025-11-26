import 'package:demo10/constants.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddGroupMember extends StatefulWidget {
  final int groupId;
  final bool isAdd;
  final List<int> memberIds;

  @override
  State createState() => _AddGroupMember();

  AddGroupMember({
    required this.groupId,
    required this.memberIds,
    required this.isAdd,
  });
}

class _AddGroupMember extends State<AddGroupMember> {
  List<int> _selectedFriends = [];
  List<String> _selectedFriendNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加成员"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (widget.isAdd) {
                await Api.instance.addGroupMembers(
                  widget.groupId,
                  _selectedFriends,
                );
              } else {
                await Api.instance.removeGroupMembers(
                  widget.groupId,
                  _selectedFriends,
                );
              }
              Navigator.pop(context);
              //这里用push
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => GroupChatPage(
              //       memberIds: _selectedFriends,
              //       ownerId: groupChatData.data.ownerId,
              //       id: groupChatData.data.groupId,
              //       name: groupChatData.data.groupName,
              //       avatarUrl: groupChatData.data.avatarUrl, //默认群头像
              //     ),
              //   ),
              // );
            },
            child: Text(
              "完成",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Friend>>(
        valueListenable: FriendListManager.instance.friends,
        builder: (context, friends, _) {
          final filteredFriends = widget.isAdd
              ? friends.where((f) => !widget.memberIds.contains(f.id)).toList()
              : friends.where((f) => widget.memberIds.contains(f.id)).toList();
          return ListView.separated(
            itemCount: filteredFriends.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = filteredFriends[index];
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
