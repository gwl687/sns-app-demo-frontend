class Comment {
  int commentId;
  int userId;
  String comment;
  DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.comment,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      userId: json['userId'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "userId": userId,
    "comment": comment,
    "createdAt": createdAt.toIso8601String(),
  };
}
