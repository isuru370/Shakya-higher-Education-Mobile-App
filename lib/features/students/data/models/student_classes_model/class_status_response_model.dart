class ClassStatusResponseModel {
  final String status;
  final String message;
  final ClassStatusRecord? record;

  ClassStatusResponseModel({
    required this.status,
    required this.message,
    this.record,
  });

  factory ClassStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassStatusResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      record: json['record'] is Map<String, dynamic>
          ? ClassStatusRecord.fromJson(json['record'])
          : null,
    );
  }
}

class ClassStatusRecord {
  final int id;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final bool status;
  final bool isFreeCard;
  final String createdAt;
  final String updatedAt;

  ClassStatusRecord({
    required this.id,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    required this.status,
    required this.isFreeCard,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassStatusRecord.fromJson(Map<String, dynamic> json) {
    return ClassStatusRecord(
      id: _parseInt(json['id']),
      studentId: _parseInt(json['student_id']),
      studentClassesId: _parseInt(json['student_classes_id']),
      classCategoryHasStudentClassId:
          _parseInt(json['class_category_has_student_class_id']),
      status: _parseBool(json['status']),
      isFreeCard: _parseBool(json['is_free_card']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}