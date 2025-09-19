import 'package:demo10/constants.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/widgets.dart';

class PersonViewModel with ChangeNotifier {
  String? username;
  bool shouldLogin = false;

  Future initData() async {
    SpUtils.getString(Constants.SP_User_Name).then((value) {
      if (value == null || value == "") {
        username = "未登录";
        shouldLogin = true;
      } else {
        username = value;
        shouldLogin = false;
      }
      notifyListeners();
    });
  }

  //退出登录
  Future logout(ValueChanged<bool> callback) async {
    bool? success = await Api.instance.logout();
    if (success == true) {
      SpUtils.removeAll;
      callback(true);
    }else{
      callback(false);
    }
  }
}
