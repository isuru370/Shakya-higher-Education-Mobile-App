import 'payment_history_model.dart';

class MonthlyPaymentModel {
  final String month;
  final String yearMonth;
  final double totalAmount;
  final int paymentCount;
  final List<PaymentHistoryModel> payments;

  MonthlyPaymentModel({
    required this.month,
    required this.yearMonth,
    required this.totalAmount,
    required this.paymentCount,
    required this.payments,
  });

  factory MonthlyPaymentModel.fromJson(Map<String, dynamic> json) {
    return MonthlyPaymentModel(
      month: json['month'] ?? '',
      yearMonth: json['year_month'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentCount: json['payment_count'] ?? 0,
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((e) => PaymentHistoryModel.fromJson(e))
          .toList(),
    );
  }
}
