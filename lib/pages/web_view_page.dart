import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebViewPage extends StatefulWidget {
  final String? title;
  final String? url;
  const WebViewPage({super.key, this.title, this.url});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  String? name;

  @override
  void initState() {
    super.initState();
    //组件初始化完成后获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        name = map["name"];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name ?? "")),
      body: SafeArea(
        child: Container(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(width: 200.w, height: 50.w, child: Text("返回")),
          ),
        ),
      ),
    );
  }
}
