import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../models/payment_history/payment_history_request_model.dart';
import '../models/payment_history/payment_history_response_model.dart';

class PaymentHistoryRemoteDataSource {
  Future<PaymentHistoryResponseModel> getPaymentHistory(
    PaymentHistoryRequestModel request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/payments/${request.studentId}/${request.studentStudentStudentClassId}',
      );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: request.token),
      );

      debugPrint('GET PAYMENT HISTORY RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET PAYMENT HISTORY RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return PaymentHistoryResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint('PAYMENT HISTORY FETCH ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      rethrow;
    }
  }
}
