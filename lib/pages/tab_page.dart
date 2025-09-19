import 'package:demo10/pages/Chat/chat_page.dart';
import 'package:demo10/pages/Chat/chat_page.dart';
import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/chat/friendChatList_page.dart';
import 'package:demo10/pages/friend/friend_page.dart';
import 'package:demo10/pages/home/home_page.dart';
import 'package:demo10/pages/home/home_page2.dart';
import 'package:demo10/pages/hot_key/hot_key_page.dart';
import 'package:demo10/pages/personal/personal_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_ui/Navigation/navigation_bar_widget.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State createState() {
    return _TabPageState();
  }
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

  void initTabData() {
    pages = [HomePage2(), FriendPage(), FriendChatList_page(), LoginPage()];
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

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      pages: pages,
      labels: labels,
      icons: icons,
      activeIcons: activeIcons,
      currentIndex: 0,
      onTabChange: (index) {},
    );
  }
}
