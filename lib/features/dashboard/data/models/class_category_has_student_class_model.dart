class ClassCategoryHasStudentClass {
  final int id;
  final double fees;

  ClassCategoryHasStudentClass({required this.id, required this.fees});

  factory ClassCategoryHasStudentClass.fromJson(Map<String, dynamic> json) {
    return ClassCategoryHasStudentClass(
      id: json['id'],
      fees: double.parse(json['fees'].toString()),
    );
  }
}
