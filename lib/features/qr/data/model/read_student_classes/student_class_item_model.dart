import 'Class_category_has_student_class_model.dart';
import 'read_student_grade_model.dart';
import 'read_student_subject_model.dart';
import 'student_class_model.dart';

class StudentClassItemModel {
  final int studentStudentStudentClassesId;
  final bool status;
  final String? inactiveText;
  final bool isFreeCard;

  final double? customFee;
  final double? discountPercentage;
  final String? discountType;
  final double? defaultFee;
  final double? finalFee;
  final String? feeType;

  final StudentClassModel studentClass;
  final ReadStudentGradeModel readStudentGrade;
  final ReadStudentSubjectModel readStudentSubject;
  final ClassCategoryHasStudentClassModel classCategory;

  StudentClassItemModel({
    required this.studentStudentStudentClassesId,
    required this.status,
    this.inactiveText,
    required this.isFreeCard,
    this.customFee,
    this.discountPercentage,
    this.discountType,
    this.defaultFee,
    this.finalFee,
    this.feeType,
    required this.studentClass,
    required this.readStudentGrade,
    required this.readStudentSubject,
    required this.classCategory,
  });

  factory StudentClassItemModel.fromJson(Map<String, dynamic> json) {
    return StudentClassItemModel(
      studentStudentStudentClassesId: _parseInt(
        json['student_student_student_classes_id'],
      ),
      status: _parseBool(json['status']),
      inactiveText: json['inactive_text']?.toString(),
      isFreeCard: _parseBool(json['is_free_card']),
      customFee: _parseDouble(json['custom_fee']),
      discountPercentage: _parseDouble(json['discount_percentage']),
      discountType: json['discount_type']?.toString(),
      defaultFee: _parseDouble(json['default_fee']),
      finalFee: _parseDouble(json['final_fee']),
      feeType: json['fee_type']?.toString(),
      studentClass: StudentClassModel.fromJson(
        json['student_class'] ?? <String, dynamic>{},
      ),
      readStudentGrade: ReadStudentGradeModel.fromJson(
        json['grade'] ?? <String, dynamic>{},
      ),
      readStudentSubject: ReadStudentSubjectModel.fromJson(
        json['subject'] ?? <String, dynamic>{},
      ),
      classCategory: ClassCategoryHasStudentClassModel.fromJson(
        json['class_category_has_student_class'] ?? <String, dynamic>{},
      ),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
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

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
