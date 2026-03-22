class StudentClassModel {
  final int id;
  final String className;
  final String? grade;
  final String? subject;

  StudentClassModel({
    required this.id,
    required this.className,
    this.grade,
    this.subject,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'],
      className: json['class_name'],
      grade: json['grade']?['grade_name'],
      subject: json['subject']?['subject_name'],
    );
  }
}
