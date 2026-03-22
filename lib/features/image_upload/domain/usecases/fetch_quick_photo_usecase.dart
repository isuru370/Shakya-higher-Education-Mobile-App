
import '../../data/models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../../data/models/fetch_quick_photo/fetch_quick_photo_response_model.dart';
import '../repository/image_upload_repository.dart';

class FetchQuickPhotoUseCase {
  final ImageUploadRepository repository;

  FetchQuickPhotoUseCase(this.repository);

  Future<FetchQuickPhotoResponseModel> call(FetchQuickPhotoRequestModel request) {
    return repository.fetch(request);
  }
}