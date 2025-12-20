// To parse this JSON data, do
//
//     final groupChatData = groupChatDataFromJson(jsonString);

import 'dart:convert';

GroupChatData groupChatDataFromJson(String str) => GroupChatData.fromJson(json.decode(str));

String groupChatDataToJson(GroupChatData data) => json.encode(data.toJson());

class GroupChatData {
  int groupId;
  String groupName;
  int ownerId;
  String avatarUrl;
  List<int> memberIds;

  GroupChatData({
    required this.groupId,
    required this.groupName,
    required this.ownerId,
    required this.avatarUrl,
    required this.memberIds,
  });

  factory GroupChatData.fromJson(Map<String, dynamic> json) => GroupChatData(
    groupId: json["groupId"],
    groupName: json["groupName"],
    ownerId: json["ownerId"],
    avatarUrl: json["avatarUrl"],
    memberIds: List<int>.from(json["memberIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "groupName": groupName,
    "ownerId": ownerId,
    "avatarUrl": avatarUrl,
    "memberIds": List<dynamic>.from(memberIds.map((x) => x)),
  };
}
