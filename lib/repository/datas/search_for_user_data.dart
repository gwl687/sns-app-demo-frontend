import 'dart:convert';

List<SearchForUserData> searchForUserDataListFromJson(String str) =>
    List<SearchForUserData>.from(
      json.decode(str).map((x) => SearchForUserData.fromJson(x)),
    );

class SearchForUserData {
  int userId;
  int? sex;
  String username;
  String? avatarurl;
  String? emailaddress;
  int? status;

  SearchForUserData({
    required this.userId,
    required this.sex,
    required this.username,
    this.avatarurl,
    this.emailaddress,
    this.status,
  });

  factory SearchForUserData.fromJson(Map<String, dynamic> json) {
    return SearchForUserData(
      userId: json['userId'],
      sex: json['sex'],
      username: json['username'],
      avatarurl: json['avatarurl'],
      emailaddress: json['emailaddress'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'sex': sex,
    'username': username,
    'avatarurl': avatarurl,
    'emailaddress': emailaddress,
    'status': status,
  };
}
