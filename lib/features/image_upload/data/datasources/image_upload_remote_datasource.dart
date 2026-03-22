import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../models/fetch_quick_photo/fetch_quick_photo_response_model.dart';
import '../models/image_upload/image_upload_request_model.dart';
import '../models/image_upload/image_upload_response_model.dart';
import '../models/quick_photo/quick_photo_response_model.dart';

class ImageUploadRemoteDatasource {
  /// 1️⃣ Upload Image
  Future<ImageUploadResponseModel> uploadImage({
    required String token,
    required ImageUploadRequestModel request,
  }) async {
    final uri = Uri.parse('${ApiConstants.apiUrl}/image-upload/upload');

    final multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.headers.addAll({'Authorization': 'Bearer $token'});

    multipartRequest.files.add(
      await http.MultipartFile.fromPath(
        'image',
        request.image.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ImageUploadResponseModel.fromJson(decoded);
    } else {
      throw Exception(decoded['message'] ?? 'Upload failed');
    }
  }

  /// 2️⃣ Create Quick Photo
  Future<QuickPhotoResponseModel> createQuickPhoto({
    required String token,
    required String imageUrl,
    required int gradeId,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/quick-photos'),
      headers: ApiConstants.headers(token: token),
      body: jsonEncode({
        'quick_img': imageUrl, // uploaded image URL from previous step
        'grade_id': gradeId, // grade selected by user
      }),
    );

    if (response.statusCode == 200) {
      return QuickPhotoResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<FetchQuickPhotoResponseModel> fetchQuickPhoto({
    required String token,
    required FetchQuickPhotoRequestModel request,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConstants.apiUrl}/quick-photos/${request.quickImageId}',
            ),
            headers: ApiConstants.headers(token: token),
          )
          .timeout(const Duration(seconds: 30));

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return FetchQuickPhotoResponseModel.fromJson(decoded);
      } else if (response.statusCode == 409) {
        throw Exception(decoded['message'] ?? 'Conflict error');
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
}
