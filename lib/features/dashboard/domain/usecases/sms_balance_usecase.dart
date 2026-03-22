import '../../data/models/sms/sms_response_model.dart';
import '../repositories/sms_repository.dart';

class SmsBalanceUseCase {
  final SmsRepository repository;

  SmsBalanceUseCase( this.repository);

  Future<SmsResponseModel> call({required String token}) async {
    return await repository.getSmsBalance(token: token);
  }
}
