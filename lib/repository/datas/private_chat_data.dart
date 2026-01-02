class PrivateChatData {
  final int id;
  final String userName;
  final String avatarUrl;

  PrivateChatData({
    required this.id,
    required this.userName,
    required this.avatarUrl,
  });

  factory PrivateChatData.fromJson(Map<String, dynamic> json) {
    return PrivateChatData(
      id: json['id'] as int,
      userName: json['userName'] as String,
      avatarUrl: json['avatarurl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'avatarurl': avatarUrl,
    };
  }
}
