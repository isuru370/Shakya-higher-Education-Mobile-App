import 'read_attendance_model.dart';

class ReadAttendanceResponseModel {
  final String status;
  final int studentId;
  final List<ReadAttendanceModel> data;
  final String? message; // optional message

  ReadAttendanceResponseModel({
    required this.status,
    required this.studentId,
    required this.data,
    this.message,
  });

  factory ReadAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if data exists and is not empty
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ReadAttendanceModel.fromJson(e))
        .toList();

    return ReadAttendanceResponseModel(
      status: json['status'] ?? 'unknown',
      studentId: json['student_id'] ?? 0,
      data: dataList,
      message: dataList.isEmpty
          ? 'Class not available'
          : null, // <-- set message
    );
  }
}
