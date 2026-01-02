import 'dart:convert';

class UserInfoData {
  int userId;
  String username;
  int sex;
  String avatarurl;
  String emailaddress;

  UserInfoData({
    required this.userId,
    required this.username,
    required this.sex,
    required this.avatarurl,
    required this.emailaddress,
  });

  factory UserInfoData.fromJson(Map<String, dynamic> json) {
    return UserInfoData(
      userId: json["userId"] as int,
      username: json["username"] as String,
      sex: json["sex"] as int,
      emailaddress: json["emailaddress"] as String,
      avatarurl: json["avatarurl"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "sex": sex,
    "avatarurl": avatarurl,
    "emailaddress": emailaddress,
  };
}
