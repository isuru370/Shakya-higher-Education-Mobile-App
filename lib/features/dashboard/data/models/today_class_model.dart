import 'class_category_has_student_class_model.dart';

class TodayClassModel {
  final int attendanceId;
  final int? status; // ✅ changed to int
  final String startTime;
  final String endTime;
  final String date;
  final bool isOngoing;
  final int classId; // ✅ added classId
  final String? className;
  final String? subjectName;
  final String? gradeName;
  final String? categoryName;
  final String? hallName;
  final String? hallType;
  final ClassCategoryHasStudentClass? classCategory;

  TodayClassModel({
    required this.attendanceId,
    this.status,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.isOngoing,
    required this.classId,
    this.className,
    this.subjectName,
    this.gradeName,
    this.categoryName,
    this.hallName,
    this.hallType,
    this.classCategory,
  });

  factory TodayClassModel.fromJson(Map<String, dynamic> json) {
    return TodayClassModel(
      attendanceId: json['attendance_id'],
      status: json['status'],
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      date: json['date'] ?? '',
      isOngoing: json['is_ongoing'] ?? false,
      classId: json['student_class']?['id'],
      className: json['student_class']?['class_name'],
      subjectName: json['subject']?['subject_name'],
      gradeName: json['grade']?['grade_name'],
      categoryName: json['category']?['category_name'],
      hallName: json['class_hall']?['hall_name'],
      hallType: json['class_hall']?['hall_type'],
      classCategory: json['class_category_has_student_class'] != null
          ? ClassCategoryHasStudentClass.fromJson(
              json['class_category_has_student_class'],
            )
          : null,
    );
  }
}
