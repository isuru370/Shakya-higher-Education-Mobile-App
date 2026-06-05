class MarkPaymentResponseModel {
  final String status;
  final String message;
  final MarkPaymentResponseDataModel data;

  const MarkPaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarkPaymentResponseModel.fromJson(Map<String, dynamic>? json) {
    return MarkPaymentResponseModel(
      status: json?['status'] as String? ?? '',

      message: json?['message'] as String? ?? '',

      data: MarkPaymentResponseDataModel.fromJson(
        json?['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class MarkPaymentResponseDataModel {
  final List<MarkPaymentResultModel> payments;

  final int count;

  const MarkPaymentResponseDataModel({
    required this.payments,
    required this.count,
  });

  factory MarkPaymentResponseDataModel.fromJson(Map<String, dynamic>? json) {
    final paymentsJson = json?['payments'] as List? ?? [];

    return MarkPaymentResponseDataModel(
      payments: paymentsJson
          .map(
            (e) => MarkPaymentResultModel.fromJson(e as Map<String, dynamic>?),
          )
          .toList(),

      count: json?['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class MarkPaymentResultModel {
  final int paymentId;

  final String receiptNumber;

  final String referenceNumber;

  final String paymentMethod;

  final String paymentMonth;

  final String paidAt;

  final String note;

  final String? guardianMobile;

  final bool smsQueued;

  const MarkPaymentResultModel({
    required this.paymentId,
    required this.receiptNumber,
    required this.referenceNumber,
    required this.paymentMethod,
    required this.paymentMonth,
    required this.paidAt,
    required this.note,
    this.guardianMobile,
    required this.smsQueued,
  });

  factory MarkPaymentResultModel.fromJson(Map<String, dynamic>? json) {
    return MarkPaymentResultModel(
      paymentId: json?['payment_id'] as int? ?? 0,

      receiptNumber: json?['receipt_number'] as String? ?? '',

      referenceNumber: json?['reference_number'] as String? ?? '',

      paymentMethod: json?['payment_method'] as String? ?? '',

      paymentMonth: json?['payment_month'] as String? ?? '',

      paidAt: json?['paid_at'] as String? ?? '',

      note: json?['note'] as String? ?? '',

      guardianMobile: json?['guardian_mobile'] as String?,

      smsQueued: json?['sms_queued'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'receipt_number': receiptNumber,
      'reference_number': referenceNumber,
      'payment_method': paymentMethod,
      'payment_month': paymentMonth,
      'paid_at': paidAt,
      'note': note,
      'guardian_mobile': guardianMobile,
      'sms_queued': smsQueued,
    };
  }
}
