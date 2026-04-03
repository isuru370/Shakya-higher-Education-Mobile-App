import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_class_data_model.dart';

class StudentClassResponseModel {
  final String status;
  final int count;
  final List<StudentClassDataModel> data;

  StudentClassResponseModel({
    required this.status,
    required this.count,
    required this.data,
  });

  factory StudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentClassResponseModel(
      status: json['status']?.toString() ?? '',
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => StudentClassDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}