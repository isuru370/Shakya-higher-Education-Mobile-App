

import '../../data/models/payment_history/payment_history_request_model.dart';
import '../../data/models/payment_history/payment_history_response_model.dart';

abstract class PaymentHistoryRepository {
  Future<PaymentHistoryResponseModel> getPaymentHistory(
      PaymentHistoryRequestModel request);
}
