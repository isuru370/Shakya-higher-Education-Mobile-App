import '../../data/model/activated_tem_qr_response_model.dart';
import '../../data/model/activated_temp_qr_request_model.dart';
import '../repository/student_temp_qr_repository.dart';

class ActivatedTempQrCodeUseCase {
  final StudentTempQrRepository repository;

  ActivatedTempQrCodeUseCase(this.repository);

  Future<ActivatedTemQrResponseModel> call(
    ActivatedTempQrRequestModel requestModel,
  ) async {
    return await repository.activatedQrCode(requestModel);
  }
}
