import 'package:nexorait_education_app/features/students/data/models/grade_model.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/teacher_mini_model.dart';
import 'package:nexorait_education_app/features/students/data/models/subject_model.dart';

class StudentClassModel {
  final String className;
  final TeacherMiniModel teacher;
  final SubjectModel subject;
  final GradeModel grade;

  StudentClassModel({
    required this.className,
    required this.teacher,
    required this.subject,
    required this.grade,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      className: json['class_name'],
      teacher: TeacherMiniModel.fromJson(json['teacher']),
      subject: SubjectModel.fromJson(json['subject']),
      grade: GradeModel.fromJson(json['grade']),
    );
  }
}
