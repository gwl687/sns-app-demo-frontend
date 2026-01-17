import 'package:camera/camera.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/interest_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

///我的个人信息页面VM
class UserProfileViewModel with ChangeNotifier {
  UserInfoData? userInfo;
  List<InterestData>? allInterests;
  final ImagePicker _picker = ImagePicker();

  ///加载我的个人信息
  Future<void> load() async {
    userInfo = await Api.instance.getUserInfo();
    allInterests = await Api.instance.getAllInterests();
    notifyListeners();
  }

  ///清空我的个人信息
  Future<void> clear() async {
    userInfo = null;
    notifyListeners();
  }

  /// 从相册选择头像并上传
  Future<void> changeAvatar() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final fileName = basename(pickedFile.path);
      await Api.instance.uploadAvatar(pickedFile.path, fileName);
      await load();
    }
  }

  /// 改名
  Future<void> changeName(String newUserName) async {
    await Api.instance.changeUserName(newUserName);
    await load();
  }

  Future<void> updateProfile(
    String username,
    int age,
    int sex,
    List<String> interests,
  ) async {}
}
