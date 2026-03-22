import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../model/read_attendance/read_attendance_response_model.dart';

class ReadAttendanceRemoteDatasource {
  Future<ReadAttendanceResponseModel> readAttendance({
    required String token,
    required String customId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.apiUrl}/attendances/read-attendance?qr_code=$customId',
      ),
      headers: ApiConstants.headers(token: token),
    );

    if (response.statusCode == 200) {
      return ReadAttendanceResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to read attendance');
    }
  }
}
