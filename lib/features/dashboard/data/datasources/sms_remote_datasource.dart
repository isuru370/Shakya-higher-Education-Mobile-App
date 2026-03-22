import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../models/sms/sms_response_model.dart';

class SmsRemoteDatasource {
  Future<SmsResponseModel> getSmsBalance({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/send-sms/balance'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('SMS BALANCE RESPONSE CODE: ${response.statusCode}');
      debugPrint('SMS BALANCE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return SmsResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('SMS BALANCE NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('SMS BALANCE ERROR: $e');
      rethrow;
    }
  }
}