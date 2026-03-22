
import '../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../data/models/attendance_history/attendance_history_response_model.dart';
import '../repositories/attendance_history_repository.dart';

class AttendanceHistoryUseCase {
  final AttendanceHistoryRepository repository;

  AttendanceHistoryUseCase(this.repository);

  Future<AttendanceHistoryResponseModel> execute(
      AttendanceHistoryRequestModel request) async {
    return await repository.getAttendanceHistory(request);
  }
}
