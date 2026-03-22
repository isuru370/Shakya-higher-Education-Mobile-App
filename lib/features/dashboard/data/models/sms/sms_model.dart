class SmsModel {
  final int statusCode;
  final String currentBalance;

  SmsModel({
    required this.statusCode,
    required this.currentBalance,
  });

  factory SmsModel.fromJson(Map<String, dynamic> json) {
    return SmsModel(
      statusCode: json['status_code'] ?? 0,
      currentBalance: json['current_balance']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'current_balance': currentBalance,
    };
  }
}