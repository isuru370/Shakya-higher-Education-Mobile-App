class AttendanceRequestModel {
  final int studentId;
  final int studentStudentClassId;
  final int attendanceId;
  final bool tute;
  final int? classCategoryHasStudentClassId;
  final String guardianMobile;

  AttendanceRequestModel({
    required this.studentId,
    required this.studentStudentClassId,
    required this.attendanceId,
    required this.tute,
    this.classCategoryHasStudentClassId,
    required this.guardianMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_student_student_classes_id': studentStudentClassId,
      'attendance_id': attendanceId,
      'tute': tute,
      'class_category_has_student_class_id': classCategoryHasStudentClassId,
      'guardian_mobile' : guardianMobile,
    };
  }
}
