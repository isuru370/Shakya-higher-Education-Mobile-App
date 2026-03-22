import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../model/read_tute/read_tute_response_model.dart';

class ReadTuteRemoteDataSource {
  Future<ReadTuteResponseModel> readTute({
    required String token,
    required String customId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.apiUrl}/tute/class-wise?qr_code=$customId'),
      headers: ApiConstants.headers(token: token),
    );

    debugPrint('GET TUTE RESPONSE CODE: ${response.statusCode}');
    debugPrint('GET TUTE RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return ReadTuteResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to read tute');
    }
  }
}
