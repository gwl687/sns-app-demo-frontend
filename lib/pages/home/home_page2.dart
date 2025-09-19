import 'dart:typed_data';

import 'package:demo10/pages/web_view_page.dart';
import 'package:demo10/route/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../common_ui/smart_refresh/smart_refresh_widget.dart';
import '../../repository/datas/home_list_data.dart';
import '../../route/routes.dart';
import 'home_vm.dart';

///路由管理类
class HomePage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage2> {
 @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Home Page"),
     ),
     body: Center(
       child: Text("这是一个空页面"),
     ),
   );
  }
}


