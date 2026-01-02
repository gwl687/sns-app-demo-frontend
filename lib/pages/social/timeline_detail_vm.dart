import 'dart:async';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/timeline/timline_post_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class TimelineDetailViewModel extends ChangeNotifier {
  UserProfileViewModel userProfileVm;

  int timelineId;

  TimelinePostData? timelinePost;

  //自己的点赞数
  int heartLikeCount = 0;

  //爱心变红
  bool heartColorChange = false;

  //总点赞数
  int totalLikeCount = 0;

  //用户id对应点赞数
  Map<int, int> avatars = {};

  //用户id对应头像url
  Map<int, String> userAvatarMap = {};

  late final StreamSubscription _sub;

  TimelineDetailViewModel({required this.timelineId,required this.userProfileVm});

  //刷新
  Future<void> load() async {
    timelinePost = await Api.instance.getTimelinePostById(timelineId);
    //自己的点赞
    heartLikeCount = timelinePost!.likedByMeCount;
    //总点赞
    totalLikeCount = timelinePost!.totalLikeCount;
    //大爱心
    if (timelinePost!.hasLikedByMe) {
      heartColorChange = true;
    } else {
      heartColorChange = false;
    }
    avatars = {};
    for (final user in timelinePost!.topLikeUsers) {
      //用户id对应点赞数
      avatars![user.userId] = user.userLikeCount;
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
    heartLikeCount++;
    //总点赞数+1
    totalLikeCount++;
    //没点赞的话，爱心变红
    heartColorChange = true;
    //如果次数超过当前avatar map次数最少的那个人，或者map大小不到20,就加入avatar map里(或增加点赞数)
    final values = avatars.values;
    int minValue = values.isEmpty
        ? 0
        : values.fold<int>(values.first, (a, b) => a < b ? a : b);
    if (avatars.length < 20 || heartLikeCount >= minValue) {
      int myId = await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
      //如果我还没点过，把我加进去toplikeusers
      if (!avatars.containsKey(myId)) {
        final avatarUrl = userProfileVm.userInfo!.avatarurl;

        userAvatarMap[myId] = (avatarUrl != null && avatarUrl.isNotEmpty)
            ? avatarUrl
            : BaseConstants.DefaultAvatarurl;
        print("添加到用户id:头像map,userAvatarMap[${myId}]=${userAvatarMap[myId]}");
      }
      avatars![myId] = heartLikeCount!;
    }
    notifyListeners();
    await Api.instance.timelineHitLike(timelineId);
  }
}
