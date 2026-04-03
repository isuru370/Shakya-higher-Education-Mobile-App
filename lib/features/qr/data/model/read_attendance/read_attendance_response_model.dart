import 'read_attendance_model.dart';

class ReadAttendanceResponseModel {
  final String status;
  final String message;
  final int studentId;
  final List<ReadAttendanceModel> data;

  ReadAttendanceResponseModel({
    required this.status,
    required this.message,
    required this.studentId,
    required this.data,
  });

  factory ReadAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadAttendanceResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      studentId: json['student_id'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ReadAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
