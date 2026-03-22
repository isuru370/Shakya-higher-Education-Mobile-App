class ReadStudentGradeModel {
  final int id;
  final String gradeName;

  ReadStudentGradeModel({
    required this.id,
    required this.gradeName,
  });

  factory ReadStudentGradeModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentGradeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      gradeName: json['grade_name']?.toString() ?? '',
    );
  }
}