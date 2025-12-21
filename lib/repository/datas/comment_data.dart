class Comment {
  int commentId;
  int timelineId;
  int userId;
  String comment;
  DateTime createdAt;

  Comment({
    required this.commentId,
    required this.timelineId,
    required this.userId,
    required this.comment,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      timelineId: json['timelineId'],
      userId: json['userId'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "timelineId": timelineId,
    "userId": userId,
    "comment": comment,
    "createdAt": createdAt.toIso8601String(),
  };
}
