class UpdateUserInfoReq {
  final int id;
  final String? username;
  final int? sex;
  final int? age;
  final String? avatarurl;
  final List<int>? interests;

  UpdateUserInfoReq({
    required this.id,
    this.username,
    this.sex,
    this.age,
    this.avatarurl,
    this.interests,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (username != null) 'username': username,
      if (sex != null) 'sex': sex,
      if (age != null) 'age': age,
      if (avatarurl != null) 'avatarurl': avatarurl,
      if (interests != null) 'interests': interests,
    };
  }
}
