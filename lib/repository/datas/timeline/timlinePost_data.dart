import 'dart:convert';

TimelinePost timelinePostFromJson(String str) =>
    TimelinePost.fromJson(json.decode(str));

String timelinePostToJson(TimelinePost data) =>
    json.encode(data.toJson());

class TimelinePost {
  String userName;
  String context;
  DateTime createdAt;
  List<String> imgUrls;

  int totalLikeCount;
  int likedByMeCount;
  List<LikeUser> topLikeUsers;

  TimelinePost({
    required this.userName,
    required this.context,
    required this.createdAt,
    required this.imgUrls,
    required this.totalLikeCount,
    required this.likedByMeCount,
    required this.topLikeUsers,
  });

  factory TimelinePost.fromJson(Map<String, dynamic> json) {
    return TimelinePost(
      userName: json['userName'] ?? '',
      context: json['context'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      imgUrls: (json['imgUrls'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      totalLikeCount: json['totalLikeCount'] ?? 0,
      likedByMeCount: json['likedByMeCount'] ?? 0,
      topLikeUsers: (json['topLikeUsers'] as List?)
          ?.map((e) => LikeUser.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "context": context,
    "createdAt": createdAt.toIso8601String(),
    "imgUrls": imgUrls,
    "totalLikeCount": totalLikeCount,
    "likedByMeCount": likedByMeCount,
    "topLikeUsers":
    topLikeUsers.map((e) => e.toJson()).toList(),
  };

  ///判断红心
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
