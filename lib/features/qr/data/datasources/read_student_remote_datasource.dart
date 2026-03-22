import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../students/data/models/student_search_model/read_student_response_model.dart';

class ReadStudentRemoteDatasource {
  Future<ReadStudentResponseModel> readPayment({
    required String token,
    required String customId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.apiUrl}/students/search?qr_code=$customId'),
      headers: ApiConstants.headers(token: token),
    );

    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return ReadStudentResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to read student: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
