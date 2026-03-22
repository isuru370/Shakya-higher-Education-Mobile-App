import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/get_classes_by_grade_request_model.dart';
import '../models/get_classes_by_grade_response_model.dart';

class GetClassesByGradeRemoteDatasource {
  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required String token,
    required GetClassesByGradeRequestModel request,
  }) async {
    try {
      final url =
          '${ApiConstants.apiUrl}/class-rooms/classes/${request.gradeId}';

      print('REQUEST URL: $url');
      print('TOKEN: $token');

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.headers(token: token),
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return GetClassesByGradeResponseModel.fromJson(decoded);
      } else {
        throw Exception(
          'Failed to fetch classes. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, s) {
      print('GET CLASSES ERROR: $e');
      print('STACKTRACE: $s');
      rethrow;
    }
  }
}
