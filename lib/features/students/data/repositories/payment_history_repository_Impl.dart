import '../../data/datasources/payment_history_remote_data_source.dart';
import '../../domain/repositories/payment_history_repository.dart';
import '../models/payment_history/payment_history_request_model.dart';
import '../models/payment_history/payment_history_response_model.dart';

class PaymentHistoryRepositoryImpl implements PaymentHistoryRepository {
  final PaymentHistoryRemoteDataSource remoteDataSource;

  PaymentHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaymentHistoryResponseModel> getPaymentHistory(
      PaymentHistoryRequestModel request) {
    return remoteDataSource.getPaymentHistory(request);
  }
}
