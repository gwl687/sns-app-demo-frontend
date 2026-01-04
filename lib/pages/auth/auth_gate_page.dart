import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/auth/register_vm.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/pages/tab_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    // 未登录
    if (!auth.isLoggedIn) {
      return const LoginPage();
    }
    // 已登录
    context.read<UserProfileViewModel>().load();
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
        ChangeNotifierProxyProvider<UserProfileViewModel, ChatListViewModel>(
          lazy: false,
          create: (_) => ChatListViewModel(),
          update: (_, userVm, chatVm) {
            chatVm!.init(userVm);
            return chatVm;
          },
        ),

        ChangeNotifierProxyProvider<UserProfileViewModel, TabViewModel>(
          lazy: false,
          create: (_) => TabViewModel(),
          update: (_, userVm, tabVm) {
            tabVm!.init(userVm);
            return tabVm;
          },
        ),

        // ChangeNotifierProxyProvider<UserProfileViewModel, TimelineViewModel>(
        //   lazy: false,
        //   create: (_) => TimelineViewModel(),
        //   update: (_, userVm, timelineVm) {
        //     timelineVm!.init(userVm);
        //     return timelineVm;
        //   },
        // ),

        ChangeNotifierProxyProvider<UserProfileViewModel, FriendViewModel>(
          lazy: false,
          create: (_) => FriendViewModel(),
          update: (_, userVm, friendVm) {
            friendVm!.init(userVm);
            return friendVm;
          },
        ),
      ],
      child: TabPage(),
    );
  }
}
