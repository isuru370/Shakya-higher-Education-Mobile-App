import '../../data/models/bulk_mark_payment_request_model.dart.dart';
import '../../data/models/mark_payment_request_model.dart';
import '../../data/models/mark_payment_response_model.dart';
import '../repositories/mark_payment_repository.dart';


class MarkPaymentUseCase {
  final MarkPaymentRepository repository;

  MarkPaymentUseCase(this.repository);

  Future<MarkPaymentResponseModel> call({
    required String token,
    required MarkPaymentRequestModel requestModel,
  }) {
    return repository.markPayment(token: token, requestModel: requestModel);
  }

  Future<MarkPaymentResponseModel> bulk({
    required String token,
    required BulkMarkPaymentRequestModel requestModel,
  }) {
    return repository.markBulkPayment(
      token: token,
      requestModel: requestModel,
    );
  }
}
