
import '../../data/models/sms/sms_response_model.dart';

abstract class SmsRepository {
  Future<SmsResponseModel> getSmsBalance({
    required String token,
  });
}