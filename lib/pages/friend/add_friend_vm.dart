import 'dart:async';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/search_for_user_data.dart';
import 'package:demo10/repository/datas/user_info_data.dart';
import 'package:flutter/cupertino.dart';

class AddFriendViewModel extends ChangeNotifier {
  Timer? _debounce;
  List<SearchForUserData> users = [];

  ///根据id搜索用户
  void searchForUsers(String keyword) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (keyword.isEmpty) {
        users = [];
        notifyListeners();
        return;
      }
      users = await Api.instance.searchForUsers(keyword);
      notifyListeners();
    });
  }

  ///发送好友申请
  void sendFriendRequest(SearchForUserData user) async {
    user.status = 2;
    notifyListeners();
    await Api.instance.sendFriendRequest(user.userId);
  }
}
