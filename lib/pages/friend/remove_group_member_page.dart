import 'package:demo10/pages/chat/group_chat_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveGroupMemberPage extends StatefulWidget {
  final GroupChatViewModel groupChatVm;

  const RemoveGroupMemberPage({super.key, required this.groupChatVm});

  @override
  State<RemoveGroupMemberPage> createState() => _RemoveGroupMemberPage();
}

class _RemoveGroupMemberPage extends State<RemoveGroupMemberPage> {
  final List<int> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remove members"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _selectedMembers.isEmpty
                ? null
                : () async {
                    await Api.instance.removeGroupMembers(
                      widget.groupChatVm.id,
                      _selectedMembers,
                    );

                    widget.groupChatVm.memberIds.removeWhere(
                      (id) => _selectedMembers.contains(id),
                    );

                    widget.groupChatVm.notifyListeners();

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Consumer<FriendViewModel>(
        builder: (context, vm, child) {
          final friends = vm.friends;

          /// 只显示「群内成员」
          final groupMembers = friends
              .where((f) => widget.groupChatVm.memberIds.contains(f.userId))
              .toList();

          if (groupMembers.isEmpty) {
            return const Center(child: Text("No members"));
          }

          return ListView.separated(
            itemCount: groupMembers.length,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            itemBuilder: (context, index) {
              final member = groupMembers[index];
              final isSelected = _selectedMembers.contains(member.userId);

              return ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedMembers.add(member.userId);
                      } else {
                        _selectedMembers.remove(member.userId);
                      }
                    });
                  },
                ),
                title: Text(member.username),
                subtitle: Text("ID: ${member.userId}"),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(member.avatarurl!),
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedMembers.remove(member.userId);
                    } else {
                      _selectedMembers.add(member.userId);
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
