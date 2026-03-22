import 'package:nexorait_education_app/features/qr/data/model/read_payment/class_category_model.dart';
import 'package:nexorait_education_app/features/qr/data/model/read_payment/latest_payment_model.dart';
import 'package:nexorait_education_app/features/qr/data/model/read_payment/student_class_model.dart';

import '../student_mini_model.dart';

class StudentPaymentModel {
  final int studentStudentStudentClassesId;
  final int studentId;
  final int classCategoryHasStudentClassId;
  final bool status;
  final bool isFreeCard;

  final StudentMiniModel student;
  final StudentClassModel studentClass;
  final ClassCategoryModel classCategory;
  final LatestPaymentModel? latestPayment;

  StudentPaymentModel({
    required this.studentStudentStudentClassesId,
    required this.studentId,
    required this.classCategoryHasStudentClassId,
    required this.status,
    required this.isFreeCard,
    required this.student,
    required this.studentClass,
    required this.classCategory,
    this.latestPayment,
  });

  factory StudentPaymentModel.fromJson(Map<String, dynamic> json) {
    return StudentPaymentModel(
      studentStudentStudentClassesId: json['student_student_student_classes_id'],
      studentId: json['student_id'],
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'],
      status: json['status'],
      isFreeCard: json['is_free_card'],
      student: StudentMiniModel.fromJson(json['student']),
      studentClass: StudentClassModel.fromJson(json['student_class']),
      classCategory: ClassCategoryModel.fromJson(
          json['class_category_has_student_class']),
      latestPayment: json['latest_payment'] != null
          ? LatestPaymentModel.fromJson(json['latest_payment'])
          : null,
    );
  }
}

