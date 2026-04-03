class CreateStudentClassModel {
  final int id;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final bool status;
  final bool isFreeCard;

  final String? inactiveText;
  final String? createdAt;
  final String? updatedAt;

  // 🔥 NEW FIELDS
  final double? customFee;
  final double? discountPercentage;
  final String? discountType;
  final double? defaultFee;
  final double? finalFee;
  final String? feeType;

  CreateStudentClassModel({
    required this.id,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    required this.status,
    required this.isFreeCard,
    this.inactiveText,
    this.createdAt,
    this.updatedAt,

    this.customFee,
    this.discountPercentage,
    this.discountType,
    this.defaultFee,
    this.finalFee,
    this.feeType,
  });

  factory CreateStudentClassModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentClassModel(
      id: _parseInt(json['id']),
      studentId: _parseInt(json['student_id']),
      studentClassesId: _parseInt(json['student_classes_id']),
      classCategoryHasStudentClassId:
          _parseInt(json['class_category_has_student_class_id']),
      status: _parseBool(json['status']),
      isFreeCard: _parseBool(json['is_free_card']),
      inactiveText: json['inactive_text']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),

      // 🔥 NEW PARSING
      customFee: _parseDouble(json['custom_fee']),
      discountPercentage: _parseDouble(json['discount_percentage']),
      discountType: json['discount_type']?.toString(),
      defaultFee: _parseDouble(json['default_fee']),
      finalFee: _parseDouble(json['final_fee']),
      feeType: json['fee_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_classes_id': studentClassesId,
      'class_category_has_student_class_id':
          classCategoryHasStudentClassId,
      'status': status,
      'is_free_card': isFreeCard,
      'inactive_text': inactiveText,
      'created_at': createdAt,
      'updated_at': updatedAt,

      // 🔥 NEW JSON
      'custom_fee': customFee,
      'discount_percentage': discountPercentage,
      'discount_type': discountType,
      'default_fee': defaultFee,
      'final_fee': finalFee,
      'fee_type': feeType,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}