import '../../data/model/read_attendance/read_attendance_response_model.dart';

abstract class ReadAttendanceRepository {
  Future<ReadAttendanceResponseModel> readAttendance(
    String token,
    String customId,
  );
}

