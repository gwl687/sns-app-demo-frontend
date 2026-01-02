import 'dart:async';

import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/user_profile_page.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/pages/friend/chat_list_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_page.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/social/timeline_page.dart';
import 'package:demo10/pages/tab_vm.dart';
import 'package:demo10/repository/api.dart';
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
    context.read<TabViewModel>().onVideoInvite =
        ({required int fromUserId, required String fromUserName}) {
          return showVideoInviteDialog(
            context: context,
            fromUserId: fromUserId,
            fromUserName: fromUserName,
          );
        };
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessageManager.instance.init();
    //初始化firebase监听
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sub = FirebaseMessageManager.instance.stream.listen((msg) {
        //主页面
        context.read<TabViewModel>().onPush(msg);
        //时间线页面
        context.read<TimelineViewModel>().onPush(msg);
        //朋友页面
        context.read<FriendViewModel>().onPush(msg);
        //聊天页面
        context.read<ChatListViewModel>().onPush(msg);
      });
    });
    initListenPublicEvent();
    initTabData();
  }

  @override
  Widget build(BuildContext context) {
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

  //公共弹窗事件实现
  bool _videoInviteShowing = false;

  Future<void> showVideoInviteDialog({
    required BuildContext context,
    required int fromUserId,
    required String fromUserName,
  }) async {
    // 防止重复弹窗
    if (_videoInviteShowing) return;
    _videoInviteShowing = true;

    final bool? accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("视频通话邀请"),
          content: Text("$fromUserName 邀请你进行视频通话"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text("拒绝"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text("接受"),
            ),
          ],
        );
      },
    );

    _videoInviteShowing = false;

    if (accepted == true) {
      // 通知对方：接受
      WebsocketManager.instance.sendMessage(
        "VIDEO_CALL_ACCEPT",
        fromUserId,
        "VIDEO_CALL_ACCEPT",
      );
      String token = await Api.instance.getLivekitToken(fromUserId);
      String myName = await context
          .read<UserProfileViewModel>()
          .userInfo!
          .username;
      // 跳转到视频页面
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoChatPage(token: token, userName: myName),
        ),
      );
    } else {
      // 通知对方：拒绝
      WebsocketManager.instance.sendMessage(
        "VIDEO_CALL_REJECT",
        fromUserId,
        "VIDEO_CALL_REJECT",
      );
    }
  }
}
