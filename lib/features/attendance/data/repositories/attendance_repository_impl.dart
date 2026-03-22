import '../datasources/attendance_remote_datasource.dart';
import '../models/atendance_request_model.dart';
import '../models/attendance_response_model.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<AttendanceResponseModel> markAttendance({
    required String token,
    required AttendanceRequestModel request,
  }) async {
    return await remoteDataSource.markAttendance(
      token: token,
      request: request,
    );
  }
}
