import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/mobile_dashboard_response_model.dart';

class MobileDashboardRemoteDataSource {
  Future<MobileDashboardResponseModel> getDashboard({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.apiUrl}/mobile-dashboard'),
      headers: ApiConstants.headers(token: token),
    );

    if (response.statusCode == 200) {
      return MobileDashboardResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load dashboard');
    }
  }
}
