class TuteModel {
  final int id;
  final String tuteFor;
  final bool activeStatus;
  final String createdAt;
  final String className;
  final String categoryName;
  final String gradeName;

  TuteModel({
    required this.id,
    required this.tuteFor,
    required this.activeStatus,
    required this.createdAt,
    required this.className,
    required this.categoryName,
    required this.gradeName,
  });

  factory TuteModel.fromJson(Map<String, dynamic> json) {
    return TuteModel(
      id: json['id'],
      tuteFor: json['tute_for'] ?? '',
      activeStatus: json['status'] ?? false,
      createdAt: json['created_at'] ?? '',
      className: json['class']?['class_name'] ?? '',
      categoryName: json['class']?['category_name'] ?? '',
      gradeName: json['class']?['grade_name'] ?? '',
    );
  }
}
