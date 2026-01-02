import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///我的个人信息页面
class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  UserInfoData? userInfoData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Mypage'), centerTitle: true),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 头像
                GestureDetector(
                  onTap: vm.changeAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(vm.userInfo!.avatarurl),
                  ),
                ),
                SizedBox(height: 20),

                // 用户名
                Text(
                  vm.userInfo!.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),

                // 退出登录
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthViewModel>().logout();
                  },
                  child: Text('Log out'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
