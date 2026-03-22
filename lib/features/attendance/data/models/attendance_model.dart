class AttendanceModel {
  final int studentId;
  final int studentClassId;
  final int attendanceId;
  final bool tute;
  final int? classCategoryHasStudentClassId; // nullable now

  AttendanceModel({
    required this.studentId,
    required this.studentClassId,
    required this.attendanceId,
    required this.tute,
    this.classCategoryHasStudentClassId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      studentId: json['student_id'] ?? 0,
      studentClassId: json['student_student_student_classes'] ?? 0,
      attendanceId: json['attendance_id'] ?? 0,
      tute: json['tute'] ?? false,
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'], // can be null
    );
  }
}
