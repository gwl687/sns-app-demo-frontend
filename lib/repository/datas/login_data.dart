// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  int code;
  dynamic msg;
  Data data;

  LoginData({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
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
  dynamic name;
  String token;
  String userName;
  int id;

  Data({
    required this.name,
    required this.token,
    required this.userName,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    token: json["token"],
    userName: json["userName"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "token": token,
    "userName": userName,
    "id": id,
  };
}
