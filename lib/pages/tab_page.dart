import 'dart:math';

import 'package:demo10/constants.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/manager/TabPageManager.dart';
import 'package:demo10/pages/Chat/chat_page.dart';
import 'package:demo10/pages/Chat/chat_page.dart';
import 'package:demo10/pages/auth/loginSuccess_page.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/friend/friendChatList_page.dart';
import 'package:demo10/pages/friend/friend_page.dart';
import 'package:demo10/pages/home/home_page.dart';
import 'package:demo10/pages/home/home_page2.dart';
import 'package:demo10/pages/hot_key/hot_key_page.dart';
import 'package:demo10/pages/personal/personal_page.dart';
import 'package:demo10/pages/social/timeline_page.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_ui/Navigation/navigation_bar_widget.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> {
  ///页面数组
  late List<Widget> pages;

  ///每个页面对应的页面可能性
  late List<Widget> loginPages;

  ///底部标题
  late List<String> labels;

  ///导航栏的icon数组:切换前
  late List<Widget> icons;

  ///导航栏的icon数组:切换后
  late List<Widget> activeIcons;
  int currentIndex = 0;

  void initTabData() {
    loginPages = [LoginPage(), LoginSuccessPage()];
    //监听页面状态
    TabPageManager.loginNotifier.addListener(_handleLoginPage);
    currentIndex = widget.initialIndex;
    pages = [
      TimelinePage(),
      FriendPage(),
      FriendChatList_page(),
      loginPages[TabPageManager.loginNotifier.value],
    ];
    labels = ["首页", "好友", "聊天", "我的"];
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

  @override
  void initState() {
    super.initState();
    initTabData();
  }

  ///登录界面内容更改
  void _handleLoginPage() {
    setState(() {
      pages[3] = loginPages[TabPageManager.loginNotifier.value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // 根据下标显示不同页面
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed, // 超过3个要加这个
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "朋友"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "聊天"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 1) {
            // 点击朋友页面时刷新
            // FriendListManager.instance.loadFriends();
            // SpUtils.getString(Constants.SP_User_Name).then((name) {
            //   print("点击刷新朋友页面,当前用户名为: $name");
            // });
          }
        },
      ),
    );
  }
}
