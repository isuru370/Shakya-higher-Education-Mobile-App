class TuteRequestModel {
  final int studentId;
  final int classCategoryStudentClassId;
  final int? year;
  final int? month;

  TuteRequestModel({
    required this.studentId,
    required this.classCategoryStudentClassId,
    this.year,
    this.month,
  });
}