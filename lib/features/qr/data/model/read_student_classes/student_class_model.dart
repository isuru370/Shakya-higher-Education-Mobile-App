class StudentClassModel {
  final int id;
  final String className;
  final String medium;

  StudentClassModel({
    required this.id,
    required this.className,
    required this.medium,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'],
      className: json['class_name'],
      medium: json['medium'],
    );
  }
}