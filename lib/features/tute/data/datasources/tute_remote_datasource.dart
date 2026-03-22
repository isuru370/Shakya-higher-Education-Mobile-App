import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../model/create_tute/create__tute_response_model.dart';
import '../model/create_tute/create_tute_request_model.dart';
import '../model/fetch_tute/tute_response_model.dart';
import '../model/tute_status/toggle_status_response_model.dart';
import '../model/tute_status/toggle_status_tute_request_model.dart';

class TuteRemoteDataSource {
  Future<TuteResponseModel> getAllTutes({
    required String token,
    required int studentId,
    required int classCategoryStudentClassId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/tute/student/'
        '$studentId/class/$classCategoryStudentClassId',
      );

      final response = await http
          .get(uri, headers: ApiConstants.headers(token: token))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return TuteResponseModel.fromJson(decoded);
      } else {
        throw HttpException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<CreateTuteResponseModel> createTute({
    required String token,
    required CreateTuteRequestModel request,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/tute');

      final response = await http.post(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()), // must have year & month, not title
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return CreateTuteResponseModel.fromJson(decoded);
      }

      if (response.statusCode == 409) {
        final decoded = jsonDecode(response.body);
        throw Exception(decoded['message']);
      }

      throw HttpException('Server error: ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ToggleStatusResponseModel> toggleStatus({
    required String token,
    required ToggleStatusTuteRequestModel request,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/tute/${request.tuteId}/toggle-status',
      );

      final response = await http.patch(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ToggleStatusResponseModel.fromJson(decoded);
      }

      if (response.statusCode == 404) {
        throw Exception('Tute not found');
      }

      if (response.statusCode == 500) {
        throw Exception('Server error');
      }

      throw HttpException('Unexpected error: ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
