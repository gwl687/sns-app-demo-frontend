class UserLoginData {
  final int id;
  final String emailaddress;
  final String token;
  final String userName;
  final String avatarUrl;

  UserLoginData({
    required this.id,
    required this.emailaddress,
    required this.token,
    required this.userName,
    required this.avatarUrl,
  });

  factory UserLoginData.fromJson(Map<String, dynamic> json) {
    return UserLoginData(
      id: json['id'],
      emailaddress: json['emailaddress'],
      token: json['token'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailaddress': emailaddress,
      'token': token,
      'userName': userName,
      'avatarUrl': avatarUrl,
    };
  }
}
