class ClassCategoryModel {
  final int classCategoryHasStudentClassId;
  final String categoryName;
  final String fees;

  ClassCategoryModel({
    required this.classCategoryHasStudentClassId,
    required this.categoryName,
    required this.fees,
  });

  factory ClassCategoryModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryModel(
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      fees: json['fees'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "class_category_has_student_class_id":
          classCategoryHasStudentClassId,
      "category_name": categoryName,
      "fees": fees,
    };
  }
}