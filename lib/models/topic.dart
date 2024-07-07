class ThesisTopic {
  final String id;
  final String name;
  final String description;

  ThesisTopic({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ThesisTopic.fromJson(Map<String, dynamic> json) {
    return ThesisTopic(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
