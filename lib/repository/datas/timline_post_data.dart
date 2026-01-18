import 'dart:convert';

import 'package:demo10/repository/datas/comment_data.dart';

TimelinePostData timelinePostFromJson(String str) =>
    TimelinePostData.fromJson(json.decode(str));

String timelinePostToJson(TimelinePostData data) => json.encode(data.toJson());

class TimelinePostData {
  /// 帖子ID
  int timelineId;
  String userName;
  String context;
  DateTime createdAt;
  List<String> imgUrls;

  /// 评论列表
  List<Comment> comments;

  /// 总点赞数
  int totalLikeCount;

  /// 当前用户点赞次数（>0 即点过赞）
  int likedByMeCount;

  /// 点赞用户（头像列表）
  List<LikeUser> topLikeUsers;

  TimelinePostData({
    required this.timelineId,
    required this.userName,
    required this.context,
    required this.createdAt,
    required this.imgUrls,
    required this.comments,
    required this.totalLikeCount,
    required this.likedByMeCount,
    required this.topLikeUsers,
  });

  factory TimelinePostData.fromJson(Map<String, dynamic> json) {
    return TimelinePostData(
      timelineId: json['timelineId'],
      userName: json['userName'] ?? '',
      context: json['context'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),

      imgUrls:
          (json['imgUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],

      comments:
          (json['comments'] as List?)
              ?.map((e) => Comment.fromJson(e))
              .toList() ??
          [],

      totalLikeCount: json['totalLikeCount'] ?? 0,
      likedByMeCount: json['likedByMeCount'] ?? 0,

      topLikeUsers:
          (json['topLikeUsers'] as List?)
              ?.map((e) => LikeUser.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "timelineId": timelineId,
    "userName": userName,
    "context": context,
    "createdAt": createdAt.toIso8601String(),
    "imgUrls": imgUrls,

    ///评论序列化
    "comments": comments.map((e) => e.toJson()).toList(),

    "totalLikeCount": totalLikeCount,
    "likedByMeCount": likedByMeCount,
    "topLikeUsers": topLikeUsers.map((e) => e.toJson()).toList(),
  };

  /// 是否点过赞（红心判断）
  bool get hasLikedByMe => likedByMeCount > 0;
}

class LikeUser {
  int userId;
  String avatarUrl;
  int userLikeCount;

  LikeUser({
    required this.userId,
    required this.avatarUrl,
    required this.userLikeCount,
  });

  factory LikeUser.fromJson(Map<String, dynamic> json) {
    return LikeUser(
      userId: json['userId'],
      avatarUrl: json['avatarUrl'] ?? '',
      userLikeCount: json['userLikeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "avatarUrl": avatarUrl,
    "userLikeCount": userLikeCount,
  };
}
