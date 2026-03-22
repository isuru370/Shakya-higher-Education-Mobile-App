import '../../domain/repositories/sms_repository.dart';
import '../datasources/sms_remote_datasource.dart';
import '../models/sms/sms_response_model.dart';

class SmsRepositoryImpl implements SmsRepository {
  final SmsRemoteDatasource remoteDatasource;

  SmsRepositoryImpl(
     this.remoteDatasource,
  );

  @override
  Future<SmsResponseModel> getSmsBalance({
    required String token,
  }) async {
    return await remoteDatasource.getSmsBalance(token: token);
  }
}