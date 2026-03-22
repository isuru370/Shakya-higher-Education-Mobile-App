import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_class_response_model.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_request_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../models/student_classes_model/class_status_request_model.dart';
import '../models/student_classes_model/class_status_response_model.dart';
import '../models/student_classes_model/create_student_request_class_model.dart';
import '../models/student_classes_model/create_student_response__class_model.dart';

class StudentClassesRemoteDataSource {
  Future<StudentClassResponseModel> getStudentsClasses(
    StudentRequestModel request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/student-classes/student/${request.studentId}/filter',
      );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: request.token),
      );

      debugPrint('GET STUDENT CLASSES RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENT CLASSES RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentClassResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint('STUDENT CLASSES FETCH ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      rethrow;
    }
  }

  Future<ClassStatusResponseModel> changeStudentClassStatus({
    required ClassStatusRequestModel request,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.apiUrl}/student-classes/toggle/${request.studentStudentStudentClassId}',
    );

    final response = await http.patch(
      uri,
      headers: ApiConstants.headers(token: request.token),
    );

    print('CLASS STATUS URL: $uri');
    print('CLASS STATUS RESPONSE CODE: ${response.statusCode}');
    print('CLASS STATUS RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return ClassStatusResponseModel.fromJson(decoded);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    } else {
      throw ServerException(
        'Failed to change class status',
        response.statusCode,
      );
    }
  }

  Future<CreateStudentClassResponseModel> createStudentClass(
    CreateStudentClassRequestModel request,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/student-classes/single');

      final response = await http.post(
        uri,
        headers: ApiConstants.headers(token: request.token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('CREATE STUDENT CLASS RESPONSE CODE: ${response.statusCode}');
      debugPrint('CREATE STUDENT CLASS RESPONSE BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CreateStudentClassResponseModel.fromJson(decoded);
      } else if (response.statusCode == 409) {
        return CreateStudentClassResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else if (response.statusCode == 422) {
        throw ValidationException('Validation failed');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint('CREATE STUDENT CLASS ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      rethrow;
    }
  }
}
