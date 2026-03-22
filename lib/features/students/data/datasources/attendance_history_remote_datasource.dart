import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../students/data/models/attendance_history/attendance_history_request_model.dart';
import '../../../students/data/models/attendance_history/attendance_history_response_model.dart';

class AttendanceHistoryRemoteDataSource {
  Future<AttendanceHistoryResponseModel> getAttendanceHistory(
    AttendanceHistoryRequestModel request,
  ) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.apiUrl}/attendances/attend/${request.studentId}/${request.classCategoryHasStudentClassId}',
      );

      final response = await http.get(
        url,
        headers: ApiConstants.headers(token: request.token), // Token if needed
      );

      debugPrint('ATTENDANCE RESPONSE CODE: ${response.statusCode}');
      debugPrint('ATTENDANCE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return AttendanceHistoryResponseModel.fromJson(
          jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized request');
      } else {
        throw ServerException(
          'Server error',
          response.statusCode,
        ); // Custom exception
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('ATTENDANCE HISTORY ERROR: $e');
      rethrow;
    }
  }
}
