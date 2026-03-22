class AttendanceHistoryRequestModel {
  final int studentId;
  final int classCategoryHasStudentClassId;
  final String token;

  AttendanceHistoryRequestModel({
    required this.studentId,
    required this.classCategoryHasStudentClassId,
    required this.token,
  });
}
