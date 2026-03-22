class ReadStudentSubjectModel {
  final int id;
  final String subjectName;

  ReadStudentSubjectModel({
    required this.id,
    required this.subjectName,
  });

  factory ReadStudentSubjectModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentSubjectModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      subjectName: json['subject_name']?.toString() ?? '',
    );
  }
}