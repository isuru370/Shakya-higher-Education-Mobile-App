class LatestPaymentModel {
  final int paymentId;
  final double amount;
  final String paymentDate;
  final String paymentForMonth;

  LatestPaymentModel({
    required this.paymentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentForMonth,
  });

  factory LatestPaymentModel.fromJson(Map<String, dynamic> json) {
    return LatestPaymentModel(
      paymentId: json['payment_id'],
      amount: double.parse(json['amount'].toString()),
      paymentDate: json['payment_date'],
      paymentForMonth: json['payment_for_month'],
    );
  }
}
