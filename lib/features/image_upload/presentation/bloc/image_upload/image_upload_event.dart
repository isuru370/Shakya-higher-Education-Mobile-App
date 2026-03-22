part of 'image_upload_bloc.dart';

sealed class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object?> get props => [];
}

/// Upload Image + Create Quick Photo
final class CreateQuickPhotoEvent extends ImageUploadEvent {
  final ImageUploadRequestModel request;
  final int? gradeId;

  const CreateQuickPhotoEvent({required this.request, this.gradeId});

  @override
  List<Object?> get props => [request, gradeId];
}

final class UploadImageEvent extends ImageUploadEvent {
  final ImageUploadRequestModel request;

  const UploadImageEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Fetch Quick Photo
final class FetchQuickPhotoEvent extends ImageUploadEvent {
  final FetchQuickPhotoRequestModel request;

  const FetchQuickPhotoEvent(this.request);

  @override
  List<Object> get props => [request];
}
