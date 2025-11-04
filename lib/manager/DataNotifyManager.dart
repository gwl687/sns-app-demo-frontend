import 'package:demo10/manager/FriendListManager.dart';
import 'package:flutter/material.dart';

class Datanotifymanager{
  //朋友栏(聊天)列表
  static ValueNotifier<List<Friend>> chatFriends = ValueNotifier([]);

  static void addFriend(int friendId, String friendName, String avatarUrl) {
    if (!chatFriends.value.contains(friendId)) {
      // 创建新的 list，触发 ValueNotifier 通知
      chatFriends.value = List.from(chatFriends.value)
        ..add(Friend(id: friendId, userName: friendName, avatarUrl: avatarUrl));
      //不能直接这样写，因为不会触发通知
      //friends.value.add(friendName);
    }
  }
}