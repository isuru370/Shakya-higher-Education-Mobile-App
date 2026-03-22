import '../students_model.dart';

class ReadStudentResponseModel {
  final String status;
  final String? message;
  final StudentModel? data;

  ReadStudentResponseModel({
    required this.status,
    this.message,
    required this.data,
  });

  factory ReadStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentResponseModel(
      status: json['status'],
      message: json['message'] ?? "Unkown",
      data: json['data'] != null ? StudentModel.fromJson(json['data']) : null,
    );
  }
}
