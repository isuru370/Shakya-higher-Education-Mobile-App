import '../../data/models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../../data/models/fetch_quick_photo/fetch_quick_photo_response_model.dart';
import '../../data/models/image_upload/image_upload_request_model.dart';
import '../../data/models/image_upload/image_upload_response_model.dart';
import '../../data/models/quick_photo/quick_photo_response_model.dart';

abstract class ImageUploadRepository {
  Future<ImageUploadResponseModel> uploadImage(
    ImageUploadRequestModel request,
  );

  Future<QuickPhotoResponseModel> createQuickPhoto({
    required String token,
    required String imageUrl,
    required int gradeId,
  });

  Future<FetchQuickPhotoResponseModel> fetch(
    FetchQuickPhotoRequestModel request,
  );
}
