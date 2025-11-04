// To parse this JSON data, do
//
//     final groupMessageDataData = groupMessageDataDataFromJson(jsonString);

import 'dart:convert';

GroupMessageDataData groupMessageDataDataFromJson(String str) => GroupMessageDataData.fromJson(json.decode(str));

String groupMessageDataDataToJson(GroupMessageDataData data) => json.encode(data.toJson());

class GroupMessageDataData {
  int id;
  int groupId;
  int senderId;
  String content;
  String type;

  GroupMessageDataData({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.type,
  });

  factory GroupMessageDataData.fromJson(Map<String, dynamic> json) => GroupMessageDataData(
    id: json["id"],
    groupId: json["groupId"],
    senderId: json["senderId"],
    content: json["content"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupId": groupId,
    "senderId": senderId,
    "content": content,
    "type": type,
  };
}
