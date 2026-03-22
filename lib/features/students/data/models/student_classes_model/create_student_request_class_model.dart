class CreateStudentClassRequestModel {
  final String token;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final int? status;
  final bool? isFreeCard;

  CreateStudentClassRequestModel({
    required this.token,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    this.status,
    this.isFreeCard,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_classes_id': studentClassesId,
      'class_category_has_student_class_id':
          classCategoryHasStudentClassId,
      'status': status,
      'is_free_card': isFreeCard,
    };
  }
}