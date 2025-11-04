// To parse this JSON data, do
//
//     final groupData = groupDataFromJson(jsonString);

import 'dart:convert';

GroupData groupDataFromJson(String str) => GroupData.fromJson(json.decode(str));

String groupDataToJson(GroupData data) => json.encode(data.toJson());

class GroupData {
  int groupId;
  String groupName;
  int ownerId;
  String avatarUrl;
  List<int> memberIds;

  GroupData({
    required this.groupId,
    required this.groupName,
    required this.ownerId,
    required this.avatarUrl,
    required this.memberIds,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
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
