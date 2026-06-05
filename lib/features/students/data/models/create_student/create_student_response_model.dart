import '../students_model.dart';

class CreateStudentResponseModel {
  final StudentModel student;

  const CreateStudentResponseModel({required this.student});

  factory CreateStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentResponseModel(
      student: StudentModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
