import '../student_mini_model.dart';

class ReadTuteModel {
  final String className;
  final int classCategoryHasStudentClassId;
  final String categoryName;
  final String gradeName;
  final StudentMiniModel student;

  ReadTuteModel({
    required this.className,
    required this.classCategoryHasStudentClassId,
    required this.categoryName,
    required this.gradeName,
    required this.student,
  });

  factory ReadTuteModel.fromJson(Map<String, dynamic> json) {
    return ReadTuteModel(
      className: json['class_name'] ?? '',
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      gradeName: json['grade_name'] ?? '',
      student: StudentMiniModel.fromJson(json['student'] ?? {}),
    );
  }
}
