import 'package:tb_pmp/models/supervisor.dart';

class Theses {
  final String id;
  final String? topicId;
  final String studentId;
  final String title;
  final String? abstract;
  final DateTime? startAt;
  final int status;
  final String? grade;
  final int? gradeBy;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Supervisor> supervisors;

  Theses({
    required this.id,
    this.topicId,
    required this.studentId,
    required this.title,
    this.abstract,
    this.startAt,
    required this.status,
    this.grade,
    this.gradeBy,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.supervisors,
  });

  factory Theses.fromJson(Map<String, dynamic> json) {
    return Theses(
      id: json['id'],
      topicId: json['topic_id'],
      studentId: json['student_id'],
      title: json['title'],
      abstract: json['abstract'],
      startAt: json['start_at'] != null ? DateTime.parse(json['start_at']) : null,
      status: json['status'],
      grade: json['grade'],
      gradeBy: json['grade_by'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      supervisors: json['supervisors'] != null
          ? List<Supervisor>.from(json['supervisors'].map((x) => Supervisor.fromJson(x)))
          : [],
    );
  }
}
