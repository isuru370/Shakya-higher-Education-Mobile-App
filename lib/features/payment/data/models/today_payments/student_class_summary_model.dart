import 'grade_summary_model.dart';
import 'subject_summary_model.dart';
import 'teacher_summary_model.dart';

class StudentClassSummaryModel {
  final int id;
  final String className;
  final GradeSummaryModel grade;
  final SubjectSummaryModel subject;
  final TeacherSummaryModel teacher;

  StudentClassSummaryModel({
    required this.id,
    required this.className,
    required this.grade,
    required this.subject,
    required this.teacher,
  });

  factory StudentClassSummaryModel.fromJson(Map<String, dynamic> json) {
    return StudentClassSummaryModel(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
      grade: GradeSummaryModel.fromJson(json['grade'] as Map<String, dynamic>),
      subject: SubjectSummaryModel.fromJson(json['subject'] as Map<String, dynamic>),
      teacher: TeacherSummaryModel.fromJson(json['teacher'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'grade': grade.toJson(),
      'subject': subject.toJson(),
      'teacher': teacher.toJson(),
    };
  }
}