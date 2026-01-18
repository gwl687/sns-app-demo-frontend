import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/request/update_user_info_req.dart';
import 'package:demo10/repository/datas/user_info_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///我的个人信息页面
class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  int? _sex;
  List<int> _selectedInterests = [];

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProfileViewModel>().userInfo!;

    _nameController = TextEditingController(text: user.username);
    _ageController = TextEditingController(text: user.age.toString());
    _sex = user.sex;
    _selectedInterests = List.from(user.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Page'), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// avatar：点了就直接传
                GestureDetector(
                  onTap: vm.changeAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(vm.userInfo!.avatarurl),
                  ),
                ),

                const SizedBox(height: 20),

                _buildNameField(),
                const SizedBox(height: 16),

                _buildAgeField(),
                const SizedBox(height: 16),

                _buildSexSelector(),
                const SizedBox(height: 16),

                _buildInterestSelector(vm),
                const SizedBox(height: 32),

                _buildSaveButton(vm),
                const SizedBox(height: 24),

                _buildLogout(vm),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= Widgets =================

  Widget _buildNameField() {
    return Row(
      children: [
        const SizedBox(width: 80, child: Text('Name')),
        Expanded(
          child: TextField(
            controller: _nameController,
            maxLength: 20,
            decoration: const InputDecoration(counterText: ''),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Row(
      children: [
        const SizedBox(width: 80, child: Text('Age')),
        Expanded(
          child: TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildSexSelector() {
    return Row(
      children: [
        const SizedBox(width: 80, child: Text('Sex')),
        DropdownButton<int>(
          value: _sex,
          items: const [
            DropdownMenuItem(value: 0, child: Text('Female')),
            DropdownMenuItem(value: 1, child: Text('Male')),
          ],
          onChanged: (v) {
            setState(() {
              _sex = v;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInterestSelector(UserProfileViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Interests', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: vm.allInterests!.map((interest) {
            final selected = _selectedInterests.contains(interest.id);
            return FilterChip(
              label: Text(interest.name),
              selected: selected,
              onSelected: (v) {
                setState(() {
                  v
                      ? _selectedInterests.add(interest.id)
                      : _selectedInterests.remove(interest.id);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(UserProfileViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onSave(vm),
        child: const Text('Save'),
      ),
    );
  }

  Widget _buildLogout(UserProfileViewModel vm) {
    return ElevatedButton(
      onPressed: () async {
        WebsocketManager.instance.close();
        vm.clear();
        await context.read<AuthViewModel>().logout();
      },
      child: const Text('Log out'),
    );
  }

  // ================= Logic =================

  Future<void> _onSave(UserProfileViewModel vm) async {
    final username = _nameController.text.trim();
    final age = int.tryParse(_ageController.text);

    if (username.isEmpty || age == null || _sex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid profile data')));
      return;
    }

    UpdateUserInfoReq updateUserInfoReq = UpdateUserInfoReq(
      id: vm.userInfo!.userId,
      username: username,
      sex: _sex,
      age: age,
      interests: _selectedInterests,
    );
    await Api.instance.updateUserInfo(updateUserInfoReq);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}
