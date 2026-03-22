import '../student_mini_model.dart';
import 'student_class_item_model.dart';

class ReadStudentClassesDataModel {
  final StudentMiniModel student;
  final List<StudentClassItemModel> classes;

  ReadStudentClassesDataModel({
    required this.student,
    required this.classes,
  });

  factory ReadStudentClassesDataModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentClassesDataModel(
      student: StudentMiniModel.fromJson(json['student']),
      classes: (json['classes'] as List)
          .map((e) => StudentClassItemModel.fromJson(e))
          .toList(),
    );
  }
}