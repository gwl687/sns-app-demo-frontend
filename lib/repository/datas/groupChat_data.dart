// To parse this JSON data, do
//
//     final groupChatData = groupChatDataFromJson(jsonString);

import 'dart:convert';

GroupChatData groupChatDataFromJson(String str) => GroupChatData.fromJson(json.decode(str));

String groupChatDataToJson(GroupChatData data) => json.encode(data.toJson());

class GroupChatData {
  int code;
  String? msg;
  Data data;

  GroupChatData({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GroupChatData.fromJson(Map<String, dynamic> json) => GroupChatData(
    code: json["code"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  int groupId;
  String groupName;
  int ownerId;
  String avatarUrl;
  List<int> memberIds;

  Data({
    required this.groupId,
    required this.groupName,
    required this.ownerId,
    required this.avatarUrl,
    required this.memberIds,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    "memberIds": List<int>.from(memberIds.map((x) => x)),
  };
}
