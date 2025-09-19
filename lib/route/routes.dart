import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/auth/register_page.dart';
import 'package:demo10/pages/home/home_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/pages/web_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.tab:
        return pageRoute(TabPage(),settings: settings);
      case RoutePath.webViewPage:
        return pageRoute(WebViewPage(title: "首页跳转来的"),settings: settings);
      case RoutePath.loginPage:
        return pageRoute(LoginPage(),settings: settings);
      case RoutePath.registerPage:
        return pageRoute(RegisterPage(),settings: settings);
    }
    return pageRoute(
      Scaffold(
        body: SafeArea(child: Center(child: Text("路由:${settings.name}不存在"))),
      ),
    );
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
      fullscreenDialog: fullscreenDialog ?? false,
      maintainState: maintainState ?? true,
      allowSnapshotting: allowSnapshotting ?? true,
    );
  }
}

//路由数据
class RoutePath {
  //首页
  static const String tab = "/";

  //网页页面
  static const String webViewPage = "/web_view_page";
  //登录
  static const String loginPage = "/login_page";
  //注册
  static const String registerPage = "/register_page";
}
