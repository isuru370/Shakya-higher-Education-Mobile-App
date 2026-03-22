import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/atendance_request_model.dart';
import '../models/attendance_response_model.dart';

class AttendanceRemoteDataSource {
  Future<AttendanceResponseModel> markAttendance({
    required String token,
    required AttendanceRequestModel request,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/attendances'),
      headers: ApiConstants.headers(token: token),
      body: jsonEncode(
        request.toJson(),
      ), // Make sure your request model has toJson()
    );

    if (response.statusCode == 200 || response.statusCode == 409) {
      // 200 = success, 409 = duplicate
      return AttendanceResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to mark attendance: ${response.body}');
    }
  }
}
