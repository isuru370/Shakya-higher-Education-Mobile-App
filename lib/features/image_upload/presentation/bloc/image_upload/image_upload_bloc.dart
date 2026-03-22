import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../../../data/models/fetch_quick_photo/fetch_quick_photo_response_model.dart';
import '../../../data/models/image_upload/image_upload_request_model.dart';
import '../../../data/models/image_upload/image_upload_response_model.dart';
import '../../../data/models/quick_photo/quick_photo_response_model.dart';
import '../../../domain/usecases/fetch_quick_photo_usecase.dart';
import '../../../domain/usecases/create_quick_photo_usecase.dart';
import '../../../domain/usecases/upload_image_usecase.dart';


part 'image_upload_event.dart';
part 'image_upload_state.dart';

class ImageUploadBloc
    extends Bloc<ImageUploadEvent, ImageUploadState> {

  final UploadImageUsecase uploadImageUsecase;
  final CreateQuickPhotoUsecase createQuickPhotoUsecase;
  final FetchQuickPhotoUseCase fetchQuickPhotoUseCase;

  ImageUploadBloc({
    required this.uploadImageUsecase,
    required this.createQuickPhotoUsecase,
    required this.fetchQuickPhotoUseCase,
  }) : super(ImageUploadInitial()) {
    on<UploadImageEvent>(_onUploadImage);
    on<CreateQuickPhotoEvent>(_onCreateQuickPhoto);
    on<FetchQuickPhotoEvent>(_onFetchQuickPhoto);
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageUploadState> emit,
  ) async {
    emit(ImageUploadLoading());

    try {
      final result =
          await uploadImageUsecase(event.request);

      emit(ImageUploadSuccess(result));
    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }

  Future<void> _onCreateQuickPhoto(
    CreateQuickPhotoEvent event,
    Emitter<ImageUploadState> emit,
  ) async {

    emit(ImageUploadLoading());

    try {
      /// 1️⃣ Upload Image
      final uploadResponse =
          await uploadImageUsecase(event.request);

      /// 2️⃣ Create Quick Photo
      final quickPhoto =
          await createQuickPhotoUsecase(
        token: event.request.token,
        imageUrl: uploadResponse.imageUrl,
        gradeId: event.gradeId!,
      );

      emit(CreateQuickPhotoSuccess(quickPhoto));

    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }

  Future<void> _onFetchQuickPhoto(
    FetchQuickPhotoEvent event,
    Emitter<ImageUploadState> emit,
  ) async {

    emit(ImageUploadLoading());

    try {
      final result =
          await fetchQuickPhotoUseCase(event.request);

      emit(FetchQuickPhotoLoaded(result));

    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }
}
