class AttendanceHistoryModel {
  final String date;
  final String status;

  AttendanceHistoryModel({
    required this.date,
    required this.status,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      date: json['date'],
      status: json['status'],
    );
  }
}
