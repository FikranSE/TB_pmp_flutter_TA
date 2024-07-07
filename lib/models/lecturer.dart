import 'dart:convert';

Lecturer lecturerFromJson(String str) => Lecturer.fromJson(json.decode(str));

String lecturerToJson(Lecturer data) => json.encode(data.toJson());

class Lecturer {
  final String id;
  final String name;

  Lecturer({
    required this.id,
    required this.name,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
