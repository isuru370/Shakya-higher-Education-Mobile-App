class CreateTuteRequestModel {
  final int studentId;
  final int classCategoryHasStudentClassId;
  final int year;
  final int month;

  CreateTuteRequestModel({
    required this.studentId,
    required this.classCategoryHasStudentClassId,
    required this.year,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'class_category_has_student_class_id':
          classCategoryHasStudentClassId,
      'year': year,
      'month': month,
    };
  }
}