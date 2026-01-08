import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
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

    // 未登录
    if (!auth.isLoggedIn) {
      return LoginPage();
    }
    // 已登录
    //context.read<UserProfileViewModel>().load();
    Permission.notification.request();
    return TabPage();

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProxyProvider<UserProfileViewModel, ChatListViewModel>(
    //       lazy: false,
    //       create: (_) => ChatListViewModel(),
    //       update: (_, userVm, chatVm) {
    //         chatVm!.init(userVm);
    //         return chatVm;
    //       },
    //     ),
    //
    //     ChangeNotifierProxyProvider<UserProfileViewModel, TabViewModel>(
    //       lazy: false,
    //       create: (_) => TabViewModel(),
    //       update: (_, userVm, tabVm) {
    //         tabVm!.init(userVm);
    //         return tabVm;
    //       },
    //     ),
    //
    //     ChangeNotifierProxyProvider<UserProfileViewModel, FriendViewModel>(
    //       lazy: false,
    //       create: (_) => FriendViewModel(),
    //       update: (_, userVm, friendVm) {
    //         friendVm!.init(userVm);
    //         return friendVm;
    //       },
    //     ),
    //   ],
    //   child: const TabPage(),
    // );
  }
}
