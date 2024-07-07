class Supervisor {
  final String id;
  final String thesisId;
  final String lecturerId;
  final int position;
  final int status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Supervisor({
    required this.id,
    required this.thesisId,
    required this.lecturerId,
    required this.position,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
    id: json['id'] ?? '',
    thesisId: json['thesis_id'] ?? '',
    lecturerId: json['lecturer_id'] ?? '',
    position: json['position'] ?? 0,
    status: json['status'] ?? 0,
    createdBy: json['created_by'] ?? '',
    createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'thesis_id': thesisId,
    'lecturer_id': lecturerId,
    'position': position,
    'status': status,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
