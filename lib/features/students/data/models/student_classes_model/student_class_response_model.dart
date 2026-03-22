import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_class_data_model.dart';

class StudentClassResponseModel {
  final String status;
  final List<StudentClassDataModel> data;

  StudentClassResponseModel({required this.status, required this.data});

  factory StudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentClassResponseModel(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => StudentClassDataModel.fromJson(e))
          .toList(),
    );
  }
}
