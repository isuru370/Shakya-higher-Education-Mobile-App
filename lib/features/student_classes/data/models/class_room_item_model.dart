import 'class_category_model.dart';

class ClassRoomItemModel {
  final int classId;
  final String className;
  final String medium;
  final String? teacherFname;
  final String? teacherLname;
  final List<ClassCategoryModel> categories;

  ClassRoomItemModel({
    required this.classId,
    required this.className,
    required this.medium,
    required this.teacherFname,
    required this.teacherLname,
    required this.categories,
  });

  factory ClassRoomItemModel.fromJson(Map<String, dynamic> json) {
    return ClassRoomItemModel(
      classId: json['class_id'] ?? 0,
      className: json['class_name'] ?? '',
      medium: json['medium'] ?? '',
      teacherFname: json['teacher_fname'],
      teacherLname: json['teacher_lname'],
      categories: (json['categories'] as List? ?? [])
          .map((e) => ClassCategoryModel.fromJson(e))
          .toList(),
    );
  }
}