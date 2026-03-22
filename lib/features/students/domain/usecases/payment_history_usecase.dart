import '../../data/models/payment_history/payment_history_request_model.dart';
import '../../data/models/payment_history/payment_history_response_model.dart';
import '../repositories/payment_history_repository.dart';

class PaymentHistoryUseCase {
  final PaymentHistoryRepository repository;

  PaymentHistoryUseCase(this.repository);

  Future<PaymentHistoryResponseModel> execute(
    PaymentHistoryRequestModel request,
  ) {
    return repository.getPaymentHistory(request);
  }
}
