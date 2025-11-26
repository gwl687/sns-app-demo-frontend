// To parse this JSON data, do
//
//     final userInfoData = userInfoDataFromJson(jsonString);

import 'dart:convert';

UserInfoData userInfoDataFromJson(String str) => UserInfoData.fromJson(json.decode(str));

String userInfoDataToJson(UserInfoData data) => json.encode(data.toJson());

class UserInfoData {
  String username;
  String sex;
  String? avatarurl;
  String? emailaddress;

  UserInfoData({
    required this.username,
    required this.sex,
    required this.avatarurl,
    required this.emailaddress,
  });

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
    username: json["username"],
    sex: json["sex"],
    avatarurl: json["avatarurl"],
    emailaddress: json["emailaddress"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "sex": sex,
    "avatarurl": avatarurl,
    "emailaddress": emailaddress,
  };
}
