import '../../data/model/student_temp_qr_model.dart';
import '../../data/model/student_temp_qr_request_model.dart';
import '../repository/student_temp_qr_repository.dart';


class FetchStudentTempQrUseCase {
  final StudentTempQrRepository studentTempQrRepository;

  FetchStudentTempQrUseCase(this.studentTempQrRepository);

  Future<List<StudentTempQrModel>> call(StudentTempQrRequestModel requestModel) async {
    return await studentTempQrRepository.fetchStudentTempQr(requestModel);
  }
}
