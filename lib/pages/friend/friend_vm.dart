import 'dart:async';

import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/search_for_user_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FriendViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  List<UserInfoData> friends = [];
  List<SearchForUserData> requestFriends = [];
  bool loaded = false;

  void init(UserProfileViewModel vm) {
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
      ///加载好友列表
      load();
    }
  }

  Future<void> load() async {
    loadRequestFriends();
    loadFriends();
  }

  //FCM处理
  void onPush(RemoteMessage msg) {
    final String type = msg.data['type'];
    final String content = msg.data['content'];
    final String title = msg.data['title'];
    if (type == 'friendRequestResponse') {
      //对方接受了我的好友申请，刷新好友列表
      if (content == "1") {
        loadFriends();
      }
    }
  }

  //加载好友
  Future<void> loadFriends() async {
    friends = await Api.instance.getFriendList();
    notifyListeners();
  }

  //加载申请成为我好友的用户
  Future<void> loadRequestFriends() async {
    requestFriends = await Api.instance.getRequestFriends();
    notifyListeners();
  }

  //回复好友申请
  Future<void> friendrequestresponse(SearchForUserData user, int res) async {
    user.status = res;
    await Api.instance.friendRequestResponse(user.userId, res);
    //如果同意，刷新自己的好友列表
    if (res == 1) {
      loadFriends();
      notifyListeners();
    }
  }
}
