class AttendanceResponseModel {
  final String status;
  final String message;
  final bool attendanceMarked;
  final bool tuteMarked;

  AttendanceResponseModel({
    required this.status,
    required this.message,
    required this.attendanceMarked,
    required this.tuteMarked,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      attendanceMarked: json['attendance_marked'] ?? false,
      tuteMarked: json['tute_marked'] ?? false,
    );
  }
}
