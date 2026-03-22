import 'Class_category_has_student_class_model.dart';
import 'read_student_grade_model.dart';
import 'read_student_subject_model.dart';
import 'student_class_model.dart';

class StudentClassItemModel {
  final int studentStudentStudentClassesId;
  final bool status;
  final bool isFreeCard;
  final StudentClassModel studentClass;
  final ReadStudentGradeModel readStudentGrade;
  final ReadStudentSubjectModel readStudentSubject;
  final ClassCategoryHasStudentClassModel classCategory;

  StudentClassItemModel({
    required this.studentStudentStudentClassesId,
    required this.status,
    required this.isFreeCard,
    required this.studentClass,
    required this.readStudentGrade,
    required this.readStudentSubject,
    required this.classCategory,
  });

  factory StudentClassItemModel.fromJson(Map<String, dynamic> json) {
    return StudentClassItemModel(
      studentStudentStudentClassesId:
          int.tryParse(json['student_student_student_classes_id'].toString()) ??
          0,
      status: json['status'] == true,
      isFreeCard: json['is_free_card'] == true,
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
}
