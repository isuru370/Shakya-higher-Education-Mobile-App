import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nexorait_education_app/features/students/data/models/create_student/create_student_response_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../models/student_custom_ids/students_custom_id_request_model.dart';
import '../models/student_custom_ids/students_custom_id_response_model.dart';
import '../models/students_model.dart';
import '../models/students_model/students_request_model.dart';
import '../models/students_model/students_response_model.dart';

class StudentRemoteDataSource {
  Future<StudentsResponseModel> getStudents(
    StudentsRequestModel request,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/students');

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: request.token),
      );

      debugPrint('GET STUDENTS RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENTS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentsResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StudentModel>> searchStudent(
    String token,
    String studentCustomId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/students/search/$studentCustomId',
      );
      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('GET STUDENTS RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENTS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> studentsJson = decoded['data'];

        return studentsJson.map((json) => StudentModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('STUDENTS FETCH ERROR: $e');
      rethrow; // let Bloc handle it
    }
  }

  Future<StudentsCustomIdResponseModel> getStudentsIds(
    StudentsCustomIdRequestModel request,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/students/custom_ids')
          .replace(
            queryParameters: {
              if (request.search != null) 'search': request.search,
              if (request.month != null) 'month': request.month,
            },
          );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: request.token),
      );

      debugPrint(
        'GET STUDENTS CUSTOM IDS RESPONSE CODE: ${response.statusCode}',
      );
      debugPrint('GET STUDENTS CUSTOM IDS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentsCustomIdResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateStudentResponseModel> createStudent(
    StudentModel student,
    String token,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/students');
      final body = jsonEncode(student.toJson());

      final response = await http.post(
        uri,
        headers: ApiConstants.headers(token: token),
        body: body,
      );

      debugPrint('CREATE STUDENT RESPONSE CODE: ${response.statusCode}');
      debugPrint('CREATE STUDENT RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;
        return CreateStudentResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server Error', response.statusCode);
      }
    } catch (e) {
      debugPrint('CREATE STUDENT ERROR: $e');
      rethrow;
    }
  }
}
