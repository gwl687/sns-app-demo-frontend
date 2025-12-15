// To parse this JSON data, do
//
//     final timelinePost = timelinePostFromJson(jsonString);

import 'dart:convert';

TimelinePost timelinePostFromJson(String str) =>
    TimelinePost.fromJson(json.decode(str));

String timelinePostToJson(TimelinePost data) => json.encode(data.toJson());

class TimelinePost {
  String context;
  String userName;
  DateTime createdAt;
  List<String> imgUrls;

  TimelinePost({
    required this.userName,
    required this.context,
    required this.createdAt,
    required this.imgUrls,
  });

  factory TimelinePost.fromJson(Map<String, dynamic> json) => TimelinePost(
    context: json["context"],
    userName: json["userName"],
    createdAt: DateTime.parse(json["createdAt"]),
    imgUrls:
        (json['imgUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "context": context,
    "userName": userName,
    "createdAt": createdAt.toIso8601String(),
    "imgUrls": List<dynamic>.from(imgUrls.map((x) => x)),
  };
}
