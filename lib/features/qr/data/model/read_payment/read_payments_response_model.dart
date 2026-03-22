import 'package:nexorait_education_app/features/qr/data/model/read_payment/student_payment_model.dart';

class ReadPaymentResponseModel {
  final String status;
  final String message;
  final List<StudentPaymentModel> data;

  ReadPaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReadPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadPaymentResponseModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => StudentPaymentModel.fromJson(e))
          .toList(),
    );
  }
}
