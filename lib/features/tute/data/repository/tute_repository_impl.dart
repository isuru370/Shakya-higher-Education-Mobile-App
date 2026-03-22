import 'package:nexorait_education_app/features/tute/data/model/create_tute/create__tute_response_model.dart';
import 'package:nexorait_education_app/features/tute/data/model/tute_status/toggle_status_response_model.dart';

import '../../domain/repository/tute_repository.dart';
import '../datasources/tute_remote_datasource.dart';
import '../model/create_tute/create_tute_request_model.dart';
import '../model/fetch_tute/tute_response_model.dart';
import '../model/tute_status/toggle_status_tute_request_model.dart';

class TuteRepositoryImpl implements TuteRepository {
  final TuteRemoteDataSource remoteDataSource;

  TuteRepositoryImpl(this.remoteDataSource);

  @override
  Future<TuteResponseModel> getAllTutes(
    String token,
    int studentId,
    int classCategoryStudentClassId,
  ) {
    return remoteDataSource.getAllTutes(
      token: token,
      studentId: studentId,
      classCategoryStudentClassId: classCategoryStudentClassId,
    );
  }

  @override
  Future<CreateTuteResponseModel> createTute(
    String token,
    CreateTuteRequestModel request,
  ) {
    return remoteDataSource.createTute(token: token, request: request);
  }

  @override
  Future<ToggleStatusResponseModel> toggleStatus(
    String token,
    ToggleStatusTuteRequestModel request,
  ) {
    return remoteDataSource.toggleStatus(token: token, request: request);
  }
}
