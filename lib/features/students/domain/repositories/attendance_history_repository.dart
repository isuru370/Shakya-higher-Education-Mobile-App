

import '../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../data/models/attendance_history/attendance_history_response_model.dart';

abstract class AttendanceHistoryRepository {
  Future<AttendanceHistoryResponseModel> getAttendanceHistory(
      AttendanceHistoryRequestModel request);
}
