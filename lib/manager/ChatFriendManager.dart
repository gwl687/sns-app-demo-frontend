import 'package:demo10/manager/FriendListManager.dart';
import 'package:flutter/material.dart';

// 管理聊天列表
class ChatFriendManager {
  // 用 ValueNotifier 让 UI 能监听变化，聊天栏页面
  static ValueNotifier<List<Friend>> friends = ValueNotifier([]);

  static void addFriend(String friendId, String friendName, String avatarUrl) {
    if (!friends.value.contains(friendId)) {
      // 创建新的 list，触发 ValueNotifier 通知
      friends.value = List.from(friends.value)
        ..add(Friend(id: friendId, userName: friendName, avatarUrl: avatarUrl));
      //不能直接这样写，因为不会触发通知
      //friends.value.add(friendName);
    }
  }
}
