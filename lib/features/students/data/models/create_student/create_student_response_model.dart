import '../students_model.dart';

class CreateStudentResponseModel {
  final StudentModel student;

  CreateStudentResponseModel({required this.student});

  factory CreateStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentResponseModel(
      student: StudentModel.fromJson(json['data']),
    );
  }
}