import 'attendance_history_model.dart';

class AttendanceHistoryResponseModel {
  final String status;
  final int totalRecords;
  final int presentCount;
  final double attendancePercentage;
  final List<AttendanceHistoryModel> data;

  AttendanceHistoryResponseModel({
    required this.status,
    required this.totalRecords,
    required this.presentCount,
    required this.attendancePercentage,
    required this.data,
  });

  factory AttendanceHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponseModel(
      status: json['status'],
      totalRecords: json['total_records'],
      presentCount: json['present_count'],
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
      data: (json['data'] as List<dynamic>)
          .map((e) => AttendanceHistoryModel.fromJson(e))
          .toList(),
    );
  }
}
