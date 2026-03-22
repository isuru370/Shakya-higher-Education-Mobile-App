import 'monthly_payment_model.dart';
import 'payment_summary_model.dart';

class PaymentHistoryResponseModel {
  final String status;
  final String message;
  final List<MonthlyPaymentModel> monthlyView;
  final PaymentSummaryModel summary;

  PaymentHistoryResponseModel({
    required this.status,
    required this.message,
    required this.monthlyView,
    required this.summary,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PaymentHistoryResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      monthlyView: (data['monthly_view'] as List<dynamic>? ?? [])
          .map((e) => MonthlyPaymentModel.fromJson(e))
          .toList(),
      summary: PaymentSummaryModel.fromJson(data['summary'] ?? {}),
    );
  }
}
