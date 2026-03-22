import '../../data/models/atendance_request_model.dart';
import '../../data/models/attendance_response_model.dart';


abstract class AttendanceRepository {
  Future<AttendanceResponseModel> markAttendance({
    required String token,
    required AttendanceRequestModel request,
  });
}
