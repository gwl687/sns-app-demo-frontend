import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/chat/group_chat_page.dart';
import 'package:demo10/pages/friend/chat_list_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/group_chat_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  // 被选中的好友
  final List<int> _selectedFriends = [];
  final List<String> _selectedFriendNames = [];

  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Create Group"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
            actions: [
              TextButton(
                onPressed: _createGroup,
                child: _creating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Create chatgroup",
                        style: TextStyle(fontSize: 14),
                      ),
              ),
            ],
          ),
          body: ListView.separated(
            itemCount: vm.friends.length,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            itemBuilder: (context, index) {
              final friend = vm.friends[index];
              final isSelected = _selectedFriends.contains(friend.userId);
              return ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (checked) => _toggleFriend(friend),
                ),
                title: Text(friend.username),
                subtitle: Text("ID: ${friend.userId}"),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(friend.avatarurl!),
                ),
                onTap: () => _toggleFriend(friend),
              );
            },
          ),
        );
      },
    );
  }

  void _toggleFriend(friend) {
    setState(() {
      if (_selectedFriends.contains(friend.userId)) {
        _selectedFriends.remove(friend.userId);
        _selectedFriendNames.remove(friend.username);
      } else {
        _selectedFriends.add(friend.userId);
        _selectedFriendNames.add(friend.username);
      }
    });
  }

  Future<void> _createGroup() async {
    if (_selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one friend.")),
      );
      return;
    }
    setState(() => _creating = true);
    try {
      await Api.instance.createGroupChat(_selectedFriends);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatListPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Create group failed: $e")));
    } finally {
      if (mounted) {
        setState(() => _creating = false);
      }
    }
  }
}
