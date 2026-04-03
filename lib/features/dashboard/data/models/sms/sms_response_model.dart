import 'sms_model.dart';

class SmsResponseModel {
  final bool success;
  final int httpStatus;
  final int providerStatusCode;
  final SmsModel data;

  SmsResponseModel({
    required this.success,
    required this.httpStatus,
    required this.providerStatusCode,
    required this.data,
  });

  factory SmsResponseModel.fromJson(Map<String, dynamic> json) {
    return SmsResponseModel(
      success: json['success'] ?? false,
      httpStatus: json['http_status'] ?? 0,
      providerStatusCode: json['provider_status_code'] ?? 0,
      data: SmsModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'http_status': httpStatus,
      'provider_status_code': providerStatusCode,
      'json': data.toJson(),
    };
  }
}
