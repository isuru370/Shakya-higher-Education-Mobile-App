import 'mark_payment_request_model.dart';

class BulkMarkPaymentRequestModel {
  final List<MarkPaymentRequestModel> payments;

  BulkMarkPaymentRequestModel({
    required this.payments,
  });

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }
}