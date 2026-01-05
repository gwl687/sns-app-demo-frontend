import 'dart:async';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/push_event_data.dart';
import 'package:demo10/repository/datas/timeline/timline_post_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TimelineViewModel extends ChangeNotifier {
  UserProfileViewModel? userProfileVm;
  bool loaded = false;

  //上面这个暂时不用，
  bool isLoading = false;
  StreamSubscription? _sub;
  List<TimelinePostData> timelinePosts = [];

  Map<int, TimelinePostData> timelinePostsMap = {};

  //自己的点赞数
  Map<int, int> heartLikeCount = {};

  //爱心变红
  Map<int, bool> heartColorChange = {};

  //总点赞数
  Map<int, int> totalLikeCount = {};

  //用户id对应点赞数
  Map<int, Map<int, int>> userLikeMap = {};

  //用户id对应头像url
  Map<int, String> userAvatarMap = {};

  TimelineViewModel() {
    _sub = FirebaseMessageManager.instance.stream.listen(onPush);
    load(200, null);
  }

  void init(UserProfileViewModel vm) {
    print("timeline init");
    userProfileVm ??= vm;
    if (!loaded && userProfileVm!.userInfo != null) {
      loaded = true;
      ///加载timeline
      load(200, null);
    }
  }

  //处理firebase推送的消息
  void onPush(PushEventData msg) {
    final type = msg.message.data['type'];
    if (type == 'timelinepost') {
      load(200, null);
    }
  }

  //清空timeline
  Future<void> clear() async {
    timelinePosts = [];
  }

  //刷新获取timeline内容
  Future<void> load(int limit, DateTime? cursor) async {
    print("timeline load");
    isLoading = true;
    timelinePosts = await Api.instance.getTimelinePost(limit, cursor);
    for (int i = 0; i < timelinePosts.length; i++) {
      final post = timelinePosts[i];
      int timelineId = post.timelineId;
      //
      timelinePostsMap[timelineId] = timelinePosts[i];
      //自己的点赞
      heartLikeCount[timelineId] = post.likedByMeCount;
      //总点赞
      totalLikeCount[timelineId] = post.totalLikeCount;
      //大爱心
      if (post.hasLikedByMe) {
        heartColorChange[timelineId] = true;
      } else {
        heartColorChange[timelineId] = false;
      }
      userLikeMap[timelineId] = {};
      for (final user in timelinePosts[i].topLikeUsers) {
        //用户id对应点赞数
        userLikeMap[timelineId]![user.userId] = user.userLikeCount;
        //用户id对应头像url
        if (!userAvatarMap.containsKey(user.userId)) {
          userAvatarMap[user.userId] = user.avatarUrl;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  //刷新单条timeline内容
  Future<void> loadByTimelineId(int timelineId) async {
    timelinePosts[timelineId] = await Api.instance.getTimelinePostById(
      timelineId,
    );
    //自己的点赞
    heartLikeCount[timelineId] = timelinePosts[timelineId].likedByMeCount;
    //总点赞
    totalLikeCount[timelineId] = timelinePosts[timelineId].totalLikeCount;
    //大爱心
    if (timelinePosts[timelineId]!.hasLikedByMe) {
      heartColorChange[timelineId] = true;
    } else {
      heartColorChange[timelineId] = false;
    }
    userLikeMap = {};
    for (final user in timelinePosts[timelineId].topLikeUsers) {
      //用户id对应点赞数
      userLikeMap[timelineId]![user.userId] = user.userLikeCount;
      //用户id对应头像url
      if (!userAvatarMap.containsKey(user.userId)) {
        userAvatarMap[user.userId] = user.avatarUrl;
      }
    }
    notifyListeners();
  }

  //点赞
  Future<void> likeHit(int timelineId) async {
    //自己的点赞数+1
    heartLikeCount[timelineId] = (heartLikeCount[timelineId] ?? 0) + 1;
    //总点赞数+1
    totalLikeCount[timelineId] = (totalLikeCount[timelineId] ?? 0) + 1;
    //没点赞的话，爱心变红
    heartColorChange[timelineId] = true;
    //如果次数超过当前avatar map次数最少的那个人，或者map大小不到20,就加入avatar map里(或增加点赞数)
    final values = userLikeMap[timelineId]?.values ?? const [];
    int minValue = values.isEmpty
        ? 0
        : values.fold<int>(values.first, (a, b) => a < b ? a : b);
    if (userLikeMap[timelineId]!.length < 20 ||
        heartLikeCount[timelineId]! >= minValue) {
      int myId = await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
      //如果我还没点过，把我加进去toplikeusers
      if (!userLikeMap[timelineId]!.containsKey(myId)) {
        final avatarUrl = userProfileVm!.userInfo!.avatarurl;
        userAvatarMap[myId] = (avatarUrl != null && avatarUrl.isNotEmpty)
            ? avatarUrl
            : BaseConstants.DefaultAvatarurl;
        print("添加到用户id:头像map,userAvatarMap[${myId}]=${userAvatarMap[myId]}");
      }
      userLikeMap[timelineId]![myId] = heartLikeCount[timelineId]!;
    }
    notifyListeners();
    await Api.instance.timelineHitLike(timelineId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
