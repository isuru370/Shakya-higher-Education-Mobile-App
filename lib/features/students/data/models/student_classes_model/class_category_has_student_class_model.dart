class ClassCategoryHasStudentClassModel {
  final double classFee;

  ClassCategoryHasStudentClassModel({required this.classFee});

  factory ClassCategoryHasStudentClassModel.fromJson(Map<String, dynamic> json) {
    final fee = json['class_fee'];
    return ClassCategoryHasStudentClassModel(
      classFee: fee is int ? fee.toDouble() : fee ?? 0.0,
    );
  }
}
