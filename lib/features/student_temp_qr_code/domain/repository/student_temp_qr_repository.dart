

import '../../data/model/activated_tem_qr_response_model.dart';
import '../../data/model/activated_temp_qr_request_model.dart';
import '../../data/model/student_temp_qr_model.dart';
import '../../data/model/student_temp_qr_request_model.dart';

abstract class StudentTempQrRepository {
  Future<List<StudentTempQrModel>> fetchStudentTempQr(StudentTempQrRequestModel requestModel);
  Future<ActivatedTemQrResponseModel> activatedQrCode(
      ActivatedTempQrRequestModel requestModel);
}
