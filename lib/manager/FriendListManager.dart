import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/friendList_data.dart';
import 'package:flutter/material.dart';

class Friend {
  final int id;
  String userName;
  String avatarUrl;

  Friend({required this.id, required this.userName, required this.avatarUrl});
}

class GroupFriend {
  int groupId;
  String groupName;
  int ownerId;
  String avatarUrl;
  List<int> memberIds;

  GroupFriend({
    required this.groupId,
    required this.groupName,
    required this.ownerId,
    required this.avatarUrl,
    required this.memberIds,
  });
}

// 管理聊天列表
class FriendListManager {
  static final FriendListManager instance = FriendListManager._();

  FriendListManager._();

  // 用 ValueNotifier 让 UI 能监听变化
  ValueNotifier<List<Friend>> friends = ValueNotifier([]);

  //清空好友列表
  void clearFriendList() {
    friends.value = [];
  }

  //获取好友列表,先看缓存，没有就拉远程到缓存
  Future<void> loadFriends() async {
    print("开始加载好友");
    try {
      FriendListData data = await Api.instance.getFriendList();
      // 把接口返回的 Data 对象映射成 Friend
      friends.value =
          data.data?.map((e) {
            return Friend(
              id: e.id,
              userName: e.userName ?? '未知',
              avatarUrl: 'https://i.pravatar.cc/150?img=${e.id}', // 简单生成头像
            );
          }).toList() ??
          [];
    } catch (e) {
      print("加载好友失败: $e");
    }
  }
}
