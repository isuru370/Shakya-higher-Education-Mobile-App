import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../model/read_student_classes/read_student_classes_response_model.dart';

class ReadStudentClassesRemoteDatasource {
  Future<ReadStudentClassesResponseModel> readStudentClass({
    required String token,
    required String qrCode,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.apiUrl}/student-classes/read?qr_code=$qrCode'),
      headers: ApiConstants.headers(token: token),
    );

    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return ReadStudentClassesResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to read student: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
