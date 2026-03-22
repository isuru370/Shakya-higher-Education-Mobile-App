class PaymentHistoryModel {
  final int id;
  final String paymentDate;
  final String displayDate;
  final double amount;
  final String paymentFor;
  final bool status;
  final String statusText;
  final String createdAt;
  final bool canEditDelete;

  PaymentHistoryModel({
    required this.id,
    required this.paymentDate,
    required this.displayDate,
    required this.amount,
    required this.paymentFor,
    required this.status,
    required this.statusText,
    required this.createdAt,
    required this.canEditDelete,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'] ?? 0,
      paymentDate: json['payment_date'] ?? '',
      displayDate: json['display_date'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentFor: json['payment_for'] ?? '',
      status: json['status'] ?? false,
      statusText: json['status_text'] ?? '',
      createdAt: json['created_at'] ?? '',
      canEditDelete: json['can_edit_delete'] ?? false,
    );
  }
}
