/// 群聊消息数据模型
class GroupMessageData {
  final int id;
  final int groupId;
  final int senderId;
  final String content;
  final String type;
  final DateTime createTime;

  GroupMessageData({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createTime,
  });

  factory GroupMessageData.fromJson(Map<String, dynamic> json) {
    return GroupMessageData(
      id: json['id'] as int,
      groupId: json['groupId'] as int,
      senderId: json['senderId'] as int,
      content: json['content'] as String,
      type: json['type'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'createTime': createTime.toIso8601String(),
    };
  }
}
