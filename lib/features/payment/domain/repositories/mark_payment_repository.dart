

import '../../data/models/bulk_mark_payment_request_model.dart.dart';
import '../../data/models/mark_payment_request_model.dart';
import '../../data/models/mark_payment_response_model.dart';

abstract class MarkPaymentRepository {
  Future<MarkPaymentResponseModel> markPayment({
    required String token,
    required MarkPaymentRequestModel requestModel,
  });

Future<MarkPaymentResponseModel> markBulkPayment({
    required String token,
    required BulkMarkPaymentRequestModel requestModel,
  });
}
