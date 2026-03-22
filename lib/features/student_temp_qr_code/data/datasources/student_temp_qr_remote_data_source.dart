import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../model/activated_tem_qr_response_model.dart';
import '../model/activated_temp_qr_request_model.dart';
import '../model/student_temp_qr_model.dart';
import '../model/student_temp_qr_request_model.dart';

class StudentTempQrRemoteDataSource {
  Future<List<StudentTempQrModel>> fetchStudentTempQr(
    StudentTempQrRequestModel requestModel,
  ) async {
    try {
      Map<String, String> queryParams = {};

      if (requestModel.search != null && requestModel.search!.isNotEmpty) {
        queryParams['search'] = requestModel.search!;
      }

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/students/temp_qr',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      debugPrint('REQUEST URL: $uri');

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: requestModel.token),
      );

      debugPrint('TEMP QR RESPONSE CODE: ${response.statusCode}');
      debugPrint('TEMP QR RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((e) => StudentTempQrModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized request');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      debugPrint('FETCH TEMP QR ERROR: $e');
      rethrow;
    }
  }

  Future<ActivatedTemQrResponseModel> tempQrActivated(
    ActivatedTempQrRequestModel requestModel,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/read-qr-code/activated/${requestModel.customId}',
      );

      debugPrint('REQUEST URL: $uri');

      final response = await http.get(
        // ✅ changed to GET
        uri,
        headers: ApiConstants.headers(token: requestModel.token),
      );

      debugPrint('ACTIVATE RESPONSE CODE: ${response.statusCode}');
      debugPrint('ACTIVATE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ActivatedTemQrResponseModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized request');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      debugPrint('ACTIVATE QR ERROR: $e');
      rethrow;
    }
  }
}
