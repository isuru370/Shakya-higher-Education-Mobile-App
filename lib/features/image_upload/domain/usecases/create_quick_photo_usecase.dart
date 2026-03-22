import '../../data/models/quick_photo/quick_photo_response_model.dart';
import '../repository/image_upload_repository.dart';

class CreateQuickPhotoUsecase {
  final ImageUploadRepository repository;

  CreateQuickPhotoUsecase(this.repository);

  Future<QuickPhotoResponseModel> call({
    required String token,
    required String imageUrl,
    required int gradeId,
  }) {
    return repository.createQuickPhoto(
      token: token,
      imageUrl: imageUrl,
      gradeId: gradeId,
    );
  }
}