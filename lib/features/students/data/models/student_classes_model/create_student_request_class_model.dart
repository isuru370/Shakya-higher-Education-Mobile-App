class CreateStudentClassRequestModel {
  final String token;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final bool? status;
  final bool? isFreeCard;
  final double? customFee;
  final double? discountPercentage;
  final String? discountType;

  CreateStudentClassRequestModel({
    required this.token,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    this.status,
    this.isFreeCard,
    this.customFee,
    this.discountPercentage,
    this.discountType,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_classes_id': studentClassesId,
      'class_category_has_student_class_id': classCategoryHasStudentClassId,
      'status': status,
      'is_free_card': isFreeCard,
      'custom_fee': customFee,
      'discount_percentage': discountPercentage,
      'discount_type': discountType,
    };
  }
}
