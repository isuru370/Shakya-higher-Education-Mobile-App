part of 'image_upload_bloc.dart';

sealed class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object> get props => [];
}

final class ImageUploadInitial extends ImageUploadState {}

final class ImageUploadLoading extends ImageUploadState {}


final class CreateQuickPhotoSuccess extends ImageUploadState {
  final QuickPhotoResponseModel response;

  const CreateQuickPhotoSuccess(this.response);

  @override
  List<Object> get props => [response];
}


final class ImageUploadSuccess extends ImageUploadState {
  final ImageUploadResponseModel response;

  const ImageUploadSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class FetchQuickPhotoLoaded extends ImageUploadState {
  final FetchQuickPhotoResponseModel result;

  const FetchQuickPhotoLoaded(this.result);

  @override
  List<Object> get props => [result];
}

final class ImageUploadError extends ImageUploadState {
  final String message;

  const ImageUploadError(this.message);

  @override
  List<Object> get props => [message];
}