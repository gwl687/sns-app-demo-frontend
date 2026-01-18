import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/search_for_user_data.dart';
import 'package:demo10/repository/datas/user_info_data.dart';
import 'package:flutter/cupertino.dart';

class RecommandedFriendViewModel extends ChangeNotifier {
  List<UserInfoData> recommandedFriend = [];

  ///获取推荐好友
  load() async {
    recommandedFriend = await Api.instance.getRecomanndedFriends();
  }

  ///发送好友申请
  void sendFriendRequest(SearchForUserData user) async {
    user.status = 2;
    notifyListeners();
    await Api.instance.sendFriendRequest(user.userId);
  }
}
