///私聊消息数据模型
class PrivateMessageData {
  final int id;
  final int receiverId;
  final int senderId;
  final String content;
  final String type;
  final DateTime createTime;

  PrivateMessageData({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createTime,
  });

  factory PrivateMessageData.fromJson(Map<String, dynamic> json) {
    return PrivateMessageData(
      id: json['id'] as int,
      receiverId: json['receiverId'] as int,
      senderId: json['senderId'] as int,
      content: json['content'] as String,
      type: json['type'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverId': receiverId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'createTime': createTime.toIso8601String(),
    };
  }
}
