
import '../../domain/repositories/mark_payment_repository.dart';
import '../datasources/mark_payment_remote_data_source.dart';
import '../models/mark_payment_request_model.dart';
import '../models/mark_payment_response_model.dart';

class MarkPaymentRepositoryImpl implements MarkPaymentRepository {
  final MarkPaymentRemoteDataSource remoteDataSource;

  MarkPaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<MarkPaymentResponseModel> markPayment({
    required String token,
    required MarkPaymentRequestModel requestModel,
  }) {
    return remoteDataSource.markPayment(token: token, requestModel: requestModel);
  }
}
