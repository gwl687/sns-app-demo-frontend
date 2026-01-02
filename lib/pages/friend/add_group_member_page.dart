import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGroupMemberPage extends StatefulWidget {
  final int groupId;
  final bool isAdd;
  final List<int> memberIds;

  @override
  State createState() => _AddGroupMember();

  AddGroupMemberPage({
    required this.groupId,
    required this.memberIds,
    required this.isAdd,
  });
}

class _AddGroupMember extends State<AddGroupMemberPage> {
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
            },
            child: Text(
              "完成",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Consumer<FriendViewModel>(
        builder: (context, vm, child) {
          final friends = vm.friends;
          final filteredFriends = widget.isAdd
              ? friends.where((f) => !widget.memberIds.contains(f.userId)).toList()
              : friends.where((f) => widget.memberIds.contains(f.userId)).toList();
          return ListView.separated(
            itemCount: filteredFriends.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = filteredFriends[index];
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
