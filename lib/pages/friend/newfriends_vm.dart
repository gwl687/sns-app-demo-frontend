import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/search_for_user_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:flutter/cupertino.dart';

class NewFriendsViewModel extends ChangeNotifier {
  List<SearchForUserData> users = [];

  NewFriendsViewModel() {
    load();
  }

  //获取正在申请成为我好友的用户
  Future<void> load() async {
    users = await Api.instance.getRequestFriends();
    notifyListeners();
  }

  //回复好友申请
  Future<void> friendrequestresponse(SearchForUserData user, int res) async {
    user.status = res;
    await Api.instance.friendRequestResponse(user.userId, res);
    if (res == 1) {

    }
  }
}
