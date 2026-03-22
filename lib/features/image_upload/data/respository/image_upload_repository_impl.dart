

import '../../domain/repository/image_upload_repository.dart';
import '../datasources/image_upload_remote_datasource.dart';
import '../models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../models/fetch_quick_photo/fetch_quick_photo_response_model.dart';
import '../models/image_upload/image_upload_request_model.dart';
import '../models/image_upload/image_upload_response_model.dart';
import '../models/quick_photo/quick_photo_response_model.dart';

class ImageUploadRepositoryImpl implements ImageUploadRepository {
  final ImageUploadRemoteDatasource remoteDatasource;

  ImageUploadRepositoryImpl(this.remoteDatasource);

  @override
  Future<ImageUploadResponseModel> uploadImage(
    ImageUploadRequestModel request,
  ) {
    return remoteDatasource.uploadImage(
      token: request.token,
      request: request,
    );
  }

  @override
  Future<QuickPhotoResponseModel> createQuickPhoto({
    required String token,
    required String imageUrl,
    required int gradeId,
  }) {
    return remoteDatasource.createQuickPhoto(
      token: token,
      imageUrl: imageUrl,
      gradeId: gradeId,
    );
  }

  @override
  Future<FetchQuickPhotoResponseModel> fetch(
    FetchQuickPhotoRequestModel request,
  ) {
    return remoteDatasource.fetchQuickPhoto(
      token: request.token,
      request: request,
    );
  }
}