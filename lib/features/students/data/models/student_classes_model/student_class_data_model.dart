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
  final bool isFreeCard;
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
    required this.isFreeCard,
    required this.joinedDate,
    required this.classCategoryHasStudentClass,
    required this.student,
    required this.studentClass,
    required this.classCategory,
  });

  factory StudentClassDataModel.fromJson(Map<String, dynamic> json) {
    return StudentClassDataModel(
      studentStudentClassId: json['student_student_student_class_id'],
      studentId: json['student_id'],
      studentClassesId: json['student_classes_id'],
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'],
      status: json['status'],
      isFreeCard: json['is_free_card'],
      joinedDate: json['joined_date'],
      classCategoryHasStudentClass: ClassCategoryHasStudentClassModel.fromJson(
        json['classCategoryHasStudentClass'],
      ),
      student: StudentMiniModel.fromJson(json['student']),
      studentClass: StudentClassModel.fromJson(json['student_class']),
      classCategory: ClassCategoryModel.fromJson(json['class_category']),
    );
  }
}
