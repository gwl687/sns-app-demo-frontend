import 'dart:async';

import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/push_event_data.dart';
import 'package:demo10/repository/datas/user/search_for_user_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FriendViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  List<UserInfoData> friends = [];
  Map<int, UserInfoData> friendMap = {};
  List<SearchForUserData> requestFriends = [];
  bool loaded = false;
  StreamSubscription? _sub;

  FriendViewModel() {
    _sub = FirebaseMessageManager.instance.stream.listen(onPush);
  }

  void init(UserProfileViewModel vm) {
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;

      ///加载好友列表
      load();
    }
  }

  Future<void> load() async {
    await loadRequestFriends();
    await loadFriends();
  }

  //FCM处理
  void onPush(PushEventData msg) {
    final String type = msg.message.data['type'];
    final String content = msg.message.data['content'];
    final String title = msg.message.data['title'];
    switch (type) {
      //对方接受了我的好友申请
      case 'friendRequestResponse':
        if (content == "1") {
          loadFriends();
        }
        break;
      //有人向我申请好友
      case 'friendrequest':
        loadRequestFriends();
        break;
      //朋友更新自己的信息
      case 'friendinfochange':
        loadFriends();
        break;
      default:
        break;
    }
  }

  //加载好友
  Future<void> loadFriends() async {
    friends = await Api.instance.getFriendList();
    friendMap = {for (final friend in friends) friend.userId: friend};
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
