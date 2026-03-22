class ClassCategoryHasStudentClassModel {
  final int id;
  final double fees;
  final String categoryName;

  ClassCategoryHasStudentClassModel({
    required this.id,
    required this.fees,
    required this.categoryName,
  });

  factory ClassCategoryHasStudentClassModel.fromJson(
      Map<String, dynamic> json) {
    return ClassCategoryHasStudentClassModel(
      id: json['id'],
      fees: double.parse(json['fees'].toString()),
      categoryName: json['class_category']['category_name'],
    );
  }
}