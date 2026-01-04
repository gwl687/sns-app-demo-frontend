import 'dart:async';

import 'package:demo10/manager/dialog_manager.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/auth/user_profile_page.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/pages/friend/chat_list_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_page.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/social/timeline_page.dart';
import 'package:demo10/pages/tab_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/private_chat_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  ///页面数组
  late List<Widget> pages;

  ///底部标题
  late List<String> labels;

  ///导航栏的icon数组:切换前
  late List<Widget> icons;

  ///导航栏的icon数组:切换后
  late List<Widget> activeIcons;

  int currentIndex = 0;

  late final StreamSubscription _sub;

  //初始化界面
  void initTabData() {
    currentIndex = widget.initialIndex;
    //暂时特殊处理timeline
    final timelineVm = context.read<TimelineViewModel>();
    final userProFileVm = context.read<UserProfileViewModel>();
    timelineVm.init(userProFileVm);
    pages = [TimelinePage(), FriendPage(), ChatListPage(), UserProfilePage()];
    labels = ["timeline", "friend", "chat", "userinfo"];
    icons = [
      Image.asset(
        "assets/images/icon_home_grey.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_hot_key_grey.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_knowledge_grey.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_personal_grey.png",
        width: 32.r,
        height: 32.r,
      ),
    ];
    activeIcons = [
      Image.asset(
        "assets/images/icon_home_selected.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_hot_key_selected.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_knowledge_selected.png",
        width: 32.r,
        height: 32.r,
      ),
      Image.asset(
        "assets/images/icon_personal_selected.png",
        width: 32.r,
        height: 32.r,
      ),
    ];
  }

  //初始化公共弹窗事件监听
  void initListenPublicEvent() {
    //视频聊天请求弹窗
    context.read<TabViewModel>().onVideoInvite =
        ({required int fromUserId, required String fromUserName}) {
          return DialogManager.instance.showVideoInviteDialog(
            context: context,
            fromUserId: fromUserId,
            fromUserName: fromUserName,
          );
        };
  }

  @override
  void initState() {
    super.initState();
    initListenPublicEvent();
    initTabData();
  }

  @override
  Widget build(BuildContext context) {
    // final tabVm = context.watch<TabViewModel>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final chatUserId = tabVm.pendingChatUserId;
    //   if (chatUserId != null) {
    //     //处理跳转
    //     final userProfileVm = context.read<UserProfileViewModel>();
    //     final chatList = context.read<ChatListViewModel>().chatList;
    //     final PrivateChatData? chatItem = chatList.firstWhere(
    //       (e) => e.id == tabVm.pendingChatUserId,
    //       orElse: () => null,
    //     );
    //     final String userName = chatItem!.userName;
    //     final String avatarUrl = chatItem.avatarUrl;
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => ChangeNotifierProvider(
    //           create: (_) => ChatViewModel(
    //             myId: userProfileVm.userInfo!.userId,
    //             friendId: tabVm.pendingChatUserId!,
    //             friendAvatarUrl: avatarUrl,
    //             friendName: userName,
    //           ),
    //           child: ChatPage(),
    //         ),
    //       ),
    //     );
    //   }
    // });

    //主页
    return Scaffold(
      body: pages[currentIndex], // 根据下标显示不同页面
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "timeline"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "friend"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "mine"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
