import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: ApiConstants.headers(),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('LOGIN RESPONSE CODE: ${response.statusCode}');
      debugPrint('LOGIN RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Invalid email or password');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      rethrow;
    }
  }

  // Optional logout API call
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.logout),
        headers: ApiConstants.headers(token: token),
      );
      debugPrint('LOGOUT RESPONSE CODE: ${response.statusCode}');
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');
    }
  }
}
