// To parse this JSON data, do
//
//     final friendListData = friendListDataFromJson(jsonString);

import 'dart:convert';

FriendListData friendListDataFromJson(String str) => FriendListData.fromJson(json.decode(str));

String friendListDataToJson(FriendListData data) => json.encode(data.toJson());

class FriendListData {
  int code;
  dynamic msg;
  List<Datum> data;

  FriendListData({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory FriendListData.fromJson(Map<String, dynamic> json) => FriendListData(
    code: json["code"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String userName;
  int id;

  Datum({
    required this.userName,
    required this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userName: json["userName"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "id": id,
  };
}
