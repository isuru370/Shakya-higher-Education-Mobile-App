class StudentClassModel {
  final int studentStudentStudentClassId;
  final bool studentClassStatus;

  StudentClassModel({
    required this.studentStudentStudentClassId,
    required this.studentClassStatus,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      studentStudentStudentClassId: json['student_student_student_class_id'],
      studentClassStatus: json['student_class_status'],
    );
  }
}
