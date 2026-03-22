class OngoingClassModel {
  final int id;
  final int classCategoryHasStudentClassId;
  final String startTime;
  final String endTime;
  final String classHallName;
  final String date;
  final bool isOngoing;
  final String currentTime;

  OngoingClassModel({
    required this.id,
    required this.classCategoryHasStudentClassId,
    required this.startTime,
    required this.endTime,
    required this.classHallName,
    required this.date,
    required this.isOngoing,
    required this.currentTime,
  });

  factory OngoingClassModel.fromJson(Map<String, dynamic> json) {
    return OngoingClassModel(
      id: json['id'],
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      classHallName: json['class_hall_name'],
      date: json['date'],
      isOngoing: json['is_ongoing'],
      currentTime: json['current_time'],
    );
  }
}
