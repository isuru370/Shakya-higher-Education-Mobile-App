class ClassCategoryModel {
  final int? categoryId;
  final String categoryName;

  ClassCategoryModel({this.categoryId, required this.categoryName});

  factory ClassCategoryModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryModel(
      categoryId: json['id'] != null ? json['id'] as int : null,
      categoryName: json['category_name'] ?? 'N/A',
    );
  }
}
