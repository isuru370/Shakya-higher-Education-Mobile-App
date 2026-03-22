import 'create_student_class_model.dart';

class CreateStudentClassResponseModel {
  final String status;
  final String message;
  final CreateStudentClassModel? record;
  final CreateStudentClassModel? existingRecord;

  CreateStudentClassResponseModel({
    required this.status,
    required this.message,
    this.record,
    this.existingRecord,
  });

  factory CreateStudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentClassResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      record: json['record'] is Map<String, dynamic>
          ? CreateStudentClassModel.fromJson(json['record'])
          : null,
      existingRecord: json['existing_record'] is Map<String, dynamic>
          ? CreateStudentClassModel.fromJson(json['existing_record'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'record': record?.toJson(),
      'existing_record': existingRecord?.toJson(),
    };
  }
}
