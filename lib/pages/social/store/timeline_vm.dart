import 'dart:async';

import 'package:demo10/constants.dart';
import 'package:demo10/manager/FirebaseMessageManager.dart';
import 'package:demo10/manager/LoginSuccessManager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/timeline/timlinePost_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TimelineViewModel extends ChangeNotifier {
  List<TimelinePost> timelinePosts = [];

  //自己的点赞数
  Map<int, int> heartLikeCount = {};

  //爱心变红
  Map<int, bool> heartColorChange = {};

  //总点赞数
  Map<int, int> totalLikeCount = {};

  //用户id对应点赞数
  Map<int, Map<int, int>> avatars = {};

  //用户id对应头像url
  Map<int, String> userAvatarMap = {};

  late final StreamSubscription _sub;

  TimelineViewModel() {
    _sub = FirebaseMessageManager.instance.stream.listen(_onMessage);
  }

  void _onMessage(RemoteMessage msg) {
    final type = msg.data['type'];
    if (type == 'gettimeline') {
      load();
    }
  }

  //清空timeline
  Future<void> clear() async {
    timelinePosts = [];
  }

  //刷新获取timeline内容
  Future<void> load() async {
    timelinePosts = await Api.instance.getTimelinePost();
    for (int i = 0; i < timelinePosts.length; i++) {
      final post = timelinePosts[i];
      //自己的点赞
      heartLikeCount[i] = post.likedByMeCount;
      //总点赞
      totalLikeCount[i] = post.totalLikeCount;
      //大爱心
      if (post.hasLikedByMe) {
        heartColorChange[i] = true;
      } else {
        heartColorChange[i] = false;
      }
      avatars[i] = {};
      for (final user in timelinePosts[i].topLikeUsers) {
        //用户id对应点赞数
        avatars[i]![user.userId] = user.userLikeCount;
        //用户id对应头像url
        if (!userAvatarMap.containsKey(user.userId)) {
          userAvatarMap[user.userId] = user.avatarUrl;
        }
      }
    }
    notifyListeners();
  }

  //点赞
  Future<void> likeHit(int postId, int timelineId) async {
    //自己的点赞数+1
    heartLikeCount[postId] = (heartLikeCount[postId] ?? 0) + 1;
    //总点赞数+1
    totalLikeCount[postId] = (totalLikeCount[postId] ?? 0) + 1;
    //没点赞的话，爱心变红
    heartColorChange[postId] = true;
    //如果次数超过当前avatar map次数最少的那个人，或者map大小不到20,就加入avatar map里(或增加点赞数)
    final values = avatars[postId]?.values ?? const [];
    int minValue = values.isEmpty
        ? 0
        : values.fold<int>(values.first, (a, b) => a < b ? a : b);
    if (avatars[postId]!.length < 20 || heartLikeCount[postId]! >= minValue) {
      int myId = await SpUtils.getInt(Constants.SP_User_Id) ?? 0;
      //如果我还没点过，把我加进去toplikeusers
      if (!avatars[postId]!.containsKey(myId)) {
        final avatarUrl = LoginSuccessManager.instance.avatarFileUrl;

        userAvatarMap[myId] = (avatarUrl != null && avatarUrl.isNotEmpty)
            ? avatarUrl
            : Constants.DefaultAvatarurl;
        print("添加到用户id:头像map,userAvatarMap[${myId}]=${userAvatarMap[myId]}");
      }
      avatars[postId]![myId] = heartLikeCount[postId]!;
    }
    notifyListeners();
    await Api.instance.timelineHitLike(timelineId);
  }
}
