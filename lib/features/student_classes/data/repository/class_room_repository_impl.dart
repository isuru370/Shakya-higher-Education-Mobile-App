import '../../domain/repository/class_room_repository.dart';
import '../datasources/get_classes_by_grade_remote_datasource.dart';
import '../models/get_classes_by_grade_request_model.dart';
import '../models/get_classes_by_grade_response_model.dart';


class ClassRoomRepositoryImpl implements ClassRoomRepository {
  final GetClassesByGradeRemoteDatasource remoteDatasource;

  ClassRoomRepositoryImpl(
     this.remoteDatasource,
  );

  @override
  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required String token,
    required String gradeId,
  }) async {
    final request = GetClassesByGradeRequestModel(
      gradeId: gradeId,
    );

    return await remoteDatasource.getClassesByGrade(
      token: token,
      request: request,
    );
  }
}