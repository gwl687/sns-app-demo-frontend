import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/search_for_user_data.dart';
import 'package:demo10/repository/datas/user_info_data.dart';
import 'package:flutter/cupertino.dart';

class NewFriendsViewModel extends ChangeNotifier {
  List<SearchForUserData> users = [];
  FriendViewModel? friendViewModel;
  late final VoidCallback _friendListener;

  NewFriendsViewModel(this.friendViewModel) {
    load();
    _friendListener = () {
      notifyListeners();
    };
    friendViewModel!.addListener(_friendListener);
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
    if (res == 1) {}
  }

  @override
  void dispose() {
    friendViewModel!.removeListener(_friendListener);
    super.dispose();
  }
}
