// To parse this JSON data, do
//
//     final groupMessageData = groupMessageDataFromJson(jsonString);

import 'dart:convert';

GroupMessageData groupMessageDataFromJson(String str) => GroupMessageData.fromJson(json.decode(str));

String groupMessageDataToJson(GroupMessageData data) => json.encode(data.toJson());

class GroupMessageData {
  int code;
  String? msg;
  List<Data> data;

  GroupMessageData({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory GroupMessageData.fromJson(Map<String, dynamic> json) => GroupMessageData(
    code: json["code"],
    msg: json["msg"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Data {
  int id;
  int groupId;
  int senderId;
  String content;
  String type;

  Data({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.type,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
