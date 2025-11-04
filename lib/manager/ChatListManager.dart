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
  ValueNotifier<List<GroupChatData>> groupList = ValueNotifier([]);

  //添加好友
  void addFriend(int friendId, String friendName, String avatarUrl) {
    if (!chatIdList.value.contains(friendId)) {
      // 创建新的 list，触发 ValueNotifier 通知
      chatList.value = List.from(chatList.value)
        ..add(Friend(id: friendId, userName: friendName, avatarUrl: avatarUrl));
      print("添加朋友(或群),名字为${friendName},id为${friendId}");
      //不能直接这样写，因为不会触发通知
      //friends.value.add(friendName);
    }
  }

  //添加群
  void addGroup(GroupChatData groupChat) {
    chatList.value = List.from(chatList.value)..add(groupChat);
    print("收到邀请，添加群聊");
  }

  //清空
  void clearChatFriendList() {
    chatList.value = [];
  }

  //load chatFriend list
  Future<void> loadFriends() async {
    var data = await Api.instance.getChatList();
    List<dynamic> chatListMembers = data['data'];
    chatListMembers.forEach((chatListMember) {
      //如果是群
      if (chatListMember['groupId'] != null) {
        print("聊天列表添加群: ${chatListMember}");
        GroupChatData groupChatData = GroupChatData(
          code: data['code'],
          msg: data['msg'],
          data: Data(
            groupId: chatListMember['groupId'],
            groupName: chatListMember['groupName'],
            ownerId: chatListMember['ownerId'],
            avatarUrl: chatListMember['avatarUrl'],
            memberIds: List<int>.from(chatListMember['memberIds']),
          ),
        );
        addGroup(groupChatData);
      } else {
        //如果是好友
        addFriend(
          chatListMember['id'],
          chatListMember['userName'],
          chatListMember['avatarurl'] ?? Constants.DefaultAvatarurl,
        );
      }
    });
  }

}
