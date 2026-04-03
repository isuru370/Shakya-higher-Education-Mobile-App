class StudentStudentClassModel {
  final int studentStudentStudentClassId;
  final bool studentClassStatus;
  final bool isFreeCard;
  final double? customFee;
  final String? discountPercentage;
  final String? discountType;
  final double defaultFee;
  final double finalFee;

  StudentStudentClassModel({
    required this.studentStudentStudentClassId,
    required this.studentClassStatus,
    required this.isFreeCard,
    this.customFee,
    this.discountPercentage,
    this.discountType,
    required this.defaultFee,
    required this.finalFee,
  });

  factory StudentStudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentStudentClassModel(
      studentStudentStudentClassId:
          json['student_student_student_class_id'] ?? 0,
      studentClassStatus: json['student_class_status'] ?? false,
      isFreeCard: json['is_free_card'] ?? false,
      customFee: json['custom_fee'] != null
          ? double.tryParse(json['custom_fee'].toString())
          : null,
      discountPercentage: json['discount_percentage']?.toString(),
      discountType: json['discount_type']?.toString(),
      defaultFee: double.tryParse(json['default_fee'].toString()) ?? 0.0,
      finalFee: double.tryParse(json['final_fee'].toString()) ?? 0.0,
    );
  }
}
