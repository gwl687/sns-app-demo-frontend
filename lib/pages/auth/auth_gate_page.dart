import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/pages/tab_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    ///未登录
    if (!auth.isLoggedIn) {
      return LoginPage();
    }

    ///已登录
    Permission.notification.request();
    return TabPage();
    // return MultiProvider(
    //   providers: [
    //     ///四个个主页面
    //     //ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
    //     ChangeNotifierProvider(create: (_) => TimelineViewModel()),
    //     ChangeNotifierProvider(create: (_) => ChatListViewModel()),
    //     ChangeNotifierProvider(create: (_) => FriendViewModel()),
    //     ///管理用主页
    //     ChangeNotifierProvider(create: (_) => TabViewModel()),
    //   ],
    //   child: TabPage(),
    // );
  }
}
