import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../model/read_payment/read_payments_response_model.dart';

class ReadPaymentRemoteDataSource {
  Future<ReadPaymentResponseModel> readPayment({
    required String token,
    required String customId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.apiUrl}/payments/mobile?qr_code=$customId'),
      headers: ApiConstants.headers(token: token),
    );

    if (response.statusCode == 200) {
      return ReadPaymentResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to read payment');
    }
  }
}
