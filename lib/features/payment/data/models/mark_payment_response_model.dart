class MarkPaymentResponseModel {
  final String status;
  final String message;
  final Map<String, dynamic>? data;

  MarkPaymentResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory MarkPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return MarkPaymentResponseModel(
      status: json['status'] ?? 'error',
      message: json['message'] ?? 'Unknown error',
      data: json['data'],
    );
  }
}
