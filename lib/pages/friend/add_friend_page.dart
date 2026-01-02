import 'package:demo10/pages/friend/add_friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddfriendPage extends StatefulWidget {
  final int myId;

  const AddfriendPage({super.key, required this.myId});

  @override
  State<AddfriendPage> createState() => _AddfriendPageState();
}

class _AddfriendPageState extends State<AddfriendPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddFriendViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('add a friend')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AddFriendViewModel>(
            builder: (context, vm, child) {
              return Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search for user...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      vm.searchForUsers(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: vm.users.isEmpty
                        ? const Center(child: Text('No user found'))
                        : ListView.builder(
                            itemCount: vm.users.length,
                            itemBuilder: (context, index) {
                              final user = vm.users[index];
                              return ListTile(
                                title: Text(user.username),
                                subtitle: Text('ID: ${user.userId}'),
                                trailing: ElevatedButton(
                                  onPressed: user.status == 2
                                      ? null
                                      : () {
                                          vm.sendFriendRequest(user);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                    backgroundColor: user.status == 2
                                        ? Colors.grey.shade300
                                        : null,
                                    foregroundColor: user.status == 2
                                        ? Colors.grey
                                        : null,
                                  ),
                                  child: Text(
                                    user.status == 2
                                        ? 'Requested'
                                        : 'Add Friend',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
