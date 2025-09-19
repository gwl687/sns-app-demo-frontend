import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'navigation_bar_item.dart';

class NavigationBarWidget extends StatefulWidget {
  NavigationBarWidget({
    super.key,
    required this.pages,
    required this.labels,
    required this.icons,
    required this.activeIcons,
    this.onTabChange,
    this.currentIndex,
  }) {
    if (pages.length != labels.length &&
        pages.length != icons.length &&
        pages.length != activeIcons.length) {
      throw Exception("数组长度必须保持一致!");
    }
  }

  ///页面数组
  final List<Widget> pages;

  ///底部标题
  final List<String> labels;

  ///导航栏的icon数组:切换前
  final List<Widget> icons;

  ///导航栏的icon数组:切换后
  final List<Widget> activeIcons;

  final ValueChanged<int>? onTabChange;

  int? currentIndex;

  @override
  State createState() {
    return _NavigationBarWidgetState();
  }
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: widget.currentIndex ?? 0,
          children: widget.pages,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.blueGrey,
          ),
          currentIndex: widget.currentIndex ?? 0,
          items: _barItemList(),
          onTap: (index) {
            //点击切换页面
            widget.currentIndex = index;
            //widget.onTabChange?.call(index);
            setState(() {});
          },
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _barItemList() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < widget.pages.length; i++) {
      items.add(
        BottomNavigationBarItem(
          label: widget.labels[i],
          activeIcon: NavigationBarItem(
            builder: (context) {
              return widget.activeIcons[i];
            },
          ),
          icon: widget.icons[i],
        ),
      );
    }
    return items;
  }
}
