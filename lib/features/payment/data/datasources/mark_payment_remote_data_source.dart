import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/mark_payment_request_model.dart';
import '../models/mark_payment_response_model.dart';

class MarkPaymentRemoteDataSource {
  Future<MarkPaymentResponseModel> markPayment({
    required String token,
    required MarkPaymentRequestModel requestModel,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/payments'),
      headers: ApiConstants.headers(token: token),
      body: jsonEncode(requestModel.toJson()),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return MarkPaymentResponseModel.fromJson(jsonBody);
    } else {
      // Pass error message from API to exception
      throw Exception(
        'Failed to mark payment: ${jsonEncode(jsonBody)}',
      ); // <-- include API message
    }
  }
}
