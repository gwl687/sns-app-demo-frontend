import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/timeline/timlinePost_data.dart';
import 'package:flutter/material.dart';

class Post{
  String? content;
  List<String>? imgUrls;
}

class TimelineViewModel extends ChangeNotifier {
  List<TimelinePost> timelinePosts = [];

  //刷新获取timeline内容
  Future<void> load() async {
    timelinePosts = await Api.instance.getTimelinePost();
    notifyListeners();
  }
}
