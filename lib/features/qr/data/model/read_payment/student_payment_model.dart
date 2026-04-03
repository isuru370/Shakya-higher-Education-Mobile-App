import 'package:nexorait_education_app/features/qr/data/model/read_payment/class_category_model.dart';
import 'package:nexorait_education_app/features/qr/data/model/read_payment/latest_payment_model.dart';
import 'package:nexorait_education_app/features/qr/data/model/read_payment/student_class_model.dart';
import '../student_mini_model.dart';

class StudentPaymentModel {
  final int studentStudentStudentClassesId;
  final int studentId;
  final int studentClassesId;
  final int classCategoryHasStudentClassId;
  final bool status;
  final String inactiveText;
  final bool isFreeCard;

  final double? customFee;
  final String? discountPercentage;
  final String? discountType;
  final double defaultFee;
  final double finalFee;
  final String feeType;

  final StudentMiniModel student;
  final StudentClassModel studentClass;
  final ClassCategoryModel classCategory;
  final LatestPaymentModel? latestPayment;

  StudentPaymentModel({
    required this.studentStudentStudentClassesId,
    required this.studentId,
    required this.studentClassesId,
    required this.classCategoryHasStudentClassId,
    required this.status,
    required this.inactiveText,
    required this.isFreeCard,
    this.customFee,
    this.discountPercentage,
    this.discountType,
    required this.defaultFee,
    required this.finalFee,
    required this.feeType,
    required this.student,
    required this.studentClass,
    required this.classCategory,
    this.latestPayment,
  });

  factory StudentPaymentModel.fromJson(Map<String, dynamic> json) {
    return StudentPaymentModel(
      studentStudentStudentClassesId:
          json['student_student_student_classes_id'],
      studentId: json['student_id'],
      studentClassesId: json['student_classes_id'],
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'],
      status: json['status'] ?? false,
      inactiveText: json['inactive_text'] ?? '',
      isFreeCard: json['is_free_card'] ?? false,
      customFee: json['custom_fee'] != null
          ? double.tryParse(json['custom_fee'].toString())
          : null,
      discountPercentage: json['discount_percentage']?.toString(),
      discountType: json['discount_type']?.toString(),
      defaultFee: double.tryParse(json['default_fee'].toString()) ?? 0.0,
      finalFee: double.tryParse(json['final_fee'].toString()) ?? 0.0,
      feeType: json['fee_type'] ?? '',
      student: StudentMiniModel.fromJson(json['student'] ?? {}),
      studentClass: StudentClassModel.fromJson(json['student_class'] ?? {}),
      classCategory: ClassCategoryModel.fromJson(
        json['class_category_has_student_class'] ?? {},
      ),
      latestPayment: json['latest_payment'] != null
          ? LatestPaymentModel.fromJson(json['latest_payment'])
          : null,
    );
  }
}
