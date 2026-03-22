
import '../../domain/repository/student_temp_qr_repository.dart';
import '../datasources/student_temp_qr_remote_data_source.dart';
import '../model/activated_tem_qr_response_model.dart';
import '../model/activated_temp_qr_request_model.dart';
import '../model/student_temp_qr_model.dart';
import '../model/student_temp_qr_request_model.dart';

class StudentTempQrRepositoryImpl implements StudentTempQrRepository {
  final StudentTempQrRemoteDataSource remoteDataSource;

  StudentTempQrRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StudentTempQrModel>> fetchStudentTempQr(
    StudentTempQrRequestModel requestModel,
  ) async {
    return await remoteDataSource.fetchStudentTempQr(requestModel);
  }

@override
Future<ActivatedTemQrResponseModel> activatedQrCode(
    ActivatedTempQrRequestModel requestModel) async {
  return await remoteDataSource.tempQrActivated(requestModel);
}
}
