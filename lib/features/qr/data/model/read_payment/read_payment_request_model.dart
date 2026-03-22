class ReadPaymentRequestModel {
  final String customId;

  ReadPaymentRequestModel({required this.customId});

  Map<String, dynamic> toQuery() {
    return {
      'custom_id': customId,
    };
  }
}
