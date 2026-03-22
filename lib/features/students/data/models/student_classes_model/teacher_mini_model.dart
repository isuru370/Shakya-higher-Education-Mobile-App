class TeacherMiniModel {
  final int teacherId;
  final String firstName;
  final String lastName;

  TeacherMiniModel({
    required this.teacherId,
    required this.firstName,
    required this.lastName,
  });

  factory TeacherMiniModel.fromJson(Map<String, dynamic> json) {
    return TeacherMiniModel(
      teacherId: json['teacher_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
