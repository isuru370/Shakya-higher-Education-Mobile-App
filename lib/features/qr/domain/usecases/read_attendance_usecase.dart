import '../repositories/read_attendance_repository.dart';
import '../../data/model/read_attendance/read_attendance_response_model.dart';

class ReadAttendanceUseCase {
  final ReadAttendanceRepository repository;

  ReadAttendanceUseCase(this.repository);

  Future<ReadAttendanceResponseModel> call(String token, String customId) {
    return repository.readAttendance(token, customId);
  }
}
