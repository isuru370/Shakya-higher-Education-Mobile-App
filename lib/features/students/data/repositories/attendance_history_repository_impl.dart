

import '../../domain/repositories/attendance_history_repository.dart';
import '../datasources/attendance_history_remote_datasource.dart';
import '../models/attendance_history/attendance_history_request_model.dart';
import '../models/attendance_history/attendance_history_response_model.dart';

class AttendanceHistoryRepositoryImpl implements AttendanceHistoryRepository {
  final AttendanceHistoryRemoteDataSource remoteDataSource;

  AttendanceHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<AttendanceHistoryResponseModel> getAttendanceHistory(
      AttendanceHistoryRequestModel request) async {
    return await remoteDataSource.getAttendanceHistory(request);
  }
}
