import '../../data/model/read_payment/read_payments_response_model.dart';
import '../repositories/read_payment_repository.dart';

class ReadPaymentUseCase {
  final ReadPaymentRepository repository;

  ReadPaymentUseCase(this.repository);

  Future<ReadPaymentResponseModel> call({
    required String token,
    required String customId,
  }) {
    return repository.readPayment(
      token: token,
      customId: customId,
    );
  }
}
