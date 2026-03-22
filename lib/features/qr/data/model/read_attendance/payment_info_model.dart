class PaymentInfoModel {
  final bool paymentStatus;
  final String lastPaymentDate;
  final String paymentFor;
  final double lastPaymentAmount;

  PaymentInfoModel({
    required this.paymentStatus,
    required this.lastPaymentDate,
    required this.paymentFor,
    required this.lastPaymentAmount,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      paymentStatus: json['payment_status'],
      lastPaymentDate: json['last_payment_date'],
      paymentFor: json['payment_for'],
      lastPaymentAmount:
          double.tryParse(json['last_payment_amount'].toString()) ?? 0.0,
    );
  }
}
