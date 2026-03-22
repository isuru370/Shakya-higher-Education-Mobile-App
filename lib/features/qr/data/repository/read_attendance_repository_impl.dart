import '../../domain/repositories/read_attendance_repository.dart';
import '../datasources/read_attendance_remote_datasource.dart';
import '../model/read_attendance/read_attendance_response_model.dart';

class ReadAttendanceRepositoryImpl implements ReadAttendanceRepository {
  final ReadAttendanceRemoteDatasource remoteDataSource;

  ReadAttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReadAttendanceResponseModel> readAttendance(
    String token,
    String customId,
  ) async {
    return remoteDataSource.readAttendance(
      token: token,
      customId: customId,
    );
  }
}
