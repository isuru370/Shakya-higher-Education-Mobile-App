class OngoingClassModel {
  final int id;
  final int classCategoryHasStudentClassId;
  final String startTime;
  final String endTime;
  final int classHallId;
  final String classHallName;
  final double classHallPrice;
  final String date;
  final bool isOngoing;
  final String currentTime;
  final bool alreadyMarked;

  OngoingClassModel({
    required this.id,
    required this.classCategoryHasStudentClassId,
    required this.startTime,
    required this.endTime,
    required this.classHallId,
    required this.classHallName,
    required this.classHallPrice,
    required this.date,
    required this.isOngoing,
    required this.currentTime,
    required this.alreadyMarked,
  });

  factory OngoingClassModel.fromJson(Map<String, dynamic> json) {
    return OngoingClassModel(
      id: json['id'] ?? 0,
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'] ?? 0,
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      classHallId: json['class_hall_id'] ?? 0,
      classHallName: json['class_hall_name']?.toString() ?? '',
      classHallPrice:
          double.tryParse(json['class_hall_price'].toString()) ?? 0.0,
      date: json['date']?.toString() ?? '',
      isOngoing: json['is_ongoing'] ?? false,
      currentTime: json['current_time']?.toString() ?? '',
      alreadyMarked: json['already_marked'] ?? false,
    );
  }
}