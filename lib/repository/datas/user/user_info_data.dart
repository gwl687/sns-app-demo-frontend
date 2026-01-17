class UserInfoData {
  int userId;
  String username;
  int sex;
  int age;
  String avatarurl;
  String emailaddress;
  List<String>? interests;

  UserInfoData({
    required this.userId,
    required this.username,
    required this.sex,
    required this.age,
    required this.avatarurl,
    required this.emailaddress,
    required this.interests,
  });

  factory UserInfoData.fromJson(Map<String, dynamic> json) {
    return UserInfoData(
      userId: json["userId"] as int,
      username: json["username"] as String,
      sex: json["sex"] as int,
      age: json["age"] as int,
      avatarurl: json["avatarurl"] as String,
      emailaddress: json["emailaddress"] as String,
      interests: (json["interests"] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "sex": sex,
    "age": age,
    "avatarurl": avatarurl,
    "emailaddress": emailaddress,
    "interests": interests,
  };
}
