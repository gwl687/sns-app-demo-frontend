class InterestData {
  final int id;
  final String name;

  InterestData({
    required this.id,
    required this.name,
  });

  factory InterestData.fromJson(Map<String, dynamic> json) {
    return InterestData(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
