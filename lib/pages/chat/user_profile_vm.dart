import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';

class UserProfileViewModel extends ChangeNotifier {

  UserProfileViewModel();

  final Map<int, String> _avatarCache = {};

  String? getAvatar(int userId) => _avatarCache[userId];

  Future<void> load(int userId) async {
    if (_avatarCache.containsKey(userId)) return;
    String avatarUrl = await Api.instance.getUserAvatarUrl(userId);
    _avatarCache[userId] = avatarUrl;
    notifyListeners();
  }
}
