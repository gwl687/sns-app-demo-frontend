import 'package:demo10/constants.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:demo10/repository/datas/group_data.dart';
import 'package:flutter/cupertino.dart';

class Chatlistmanager {
  static final Chatlistmanager instance = Chatlistmanager._();

  Chatlistmanager._();

  ValueNotifier<List<dynamic>> chatList = ValueNotifier([]);
  ValueNotifier<List<int>> chatIdList = ValueNotifier([]);
  ValueNotifier<List<int>> groupIdList = ValueNotifier([]);

  //添加好友
  void addFriend(int friendId, String friendName, String avatarUrl) {
    if (!chatIdList.value.contains(friendId)) {
      // 创建新的 list，触发 ValueNotifier 通知
      chatList.value = List.from(chatList.value)
        ..add(Friend(id: friendId, userName: friendName, avatarUrl: avatarUrl));
      chatIdList.value.add(friendId);
      print("添加朋友(或群),名字为${friendName},id为${friendId}");
    }
  }

  //刷新好友

  //添加群
  void addGroup(GroupChatData groupChat) {
    if (!groupIdList.value.contains(groupChat.groupId)) {
      chatList.value = List.from(chatList.value)..add(groupChat);
      groupIdList.value.add(groupChat.groupId);
      print("收到邀请，添加群聊");
    }
  }

  //清空
  void clearChatFriendList() {
    groupIdList.value = [];
    chatIdList.value = [];
    chatList.value = [];
  }

  //load chatFriend list
  Future<void> loadFriends() async {

  }
}
