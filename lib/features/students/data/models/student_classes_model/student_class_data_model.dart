import 'package:nexorait_education_app/features/students/data/models/student_classes_model/class_category_has_student_class_model.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_class_model.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_mini_model.dart';

import 'class_category_model.dart';

class StudentClassDataModel {
  final int studentStudentClassId;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final bool status;
  final String inactiveText;
  final bool isFreeCard;
  final double? customFee;
  final double? discountPercentage;
  final String? discountType;
  final double defaultFee;
  final double finalFee;
  final String feeType;
  final String joinedDate;

  final ClassCategoryHasStudentClassModel classCategoryHasStudentClass;
  final StudentMiniModel student;
  final StudentClassModel studentClass;
  final ClassCategoryModel classCategory;

  StudentClassDataModel({
    required this.studentStudentClassId,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    required this.status,
    required this.inactiveText,
    required this.isFreeCard,
    required this.customFee,
    required this.discountPercentage,
    required this.discountType,
    required this.defaultFee,
    required this.finalFee,
    required this.feeType,
    required this.joinedDate,
    required this.classCategoryHasStudentClass,
    required this.student,
    required this.studentClass,
    required this.classCategory,
  });

  factory StudentClassDataModel.fromJson(Map<String, dynamic> json) {
    double? parseNullableDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return StudentClassDataModel(
      studentStudentClassId: json['student_student_student_class_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentClassesId: json['student_classes_id'] ?? 0,
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'] ?? 0,
      status: json['status'] ?? false,
      inactiveText: json['inactive_text']?.toString() ?? '',
      isFreeCard: json['is_free_card'] ?? false,
      customFee: parseNullableDouble(json['custom_fee']),
      discountPercentage: parseNullableDouble(json['discount_percentage']),
      discountType: json['discount_type']?.toString(),
      defaultFee: parseDouble(json['default_fee']),
      finalFee: parseDouble(json['final_fee']),
      feeType: json['fee_type']?.toString() ?? '',
      joinedDate: json['joined_date']?.toString() ?? '',
      classCategoryHasStudentClass: ClassCategoryHasStudentClassModel.fromJson(
        json['class_category_has_student_class'] ?? {},
      ),
      student: StudentMiniModel.fromJson(json['student'] ?? {}),
      studentClass: StudentClassModel.fromJson(json['student_class'] ?? {}),
      classCategory: ClassCategoryModel.fromJson(json['class_category'] ?? {}),
    );
  }
}