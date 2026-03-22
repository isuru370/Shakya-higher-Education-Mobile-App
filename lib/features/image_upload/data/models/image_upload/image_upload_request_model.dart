import 'dart:io';

class ImageUploadRequestModel {
  final File image;
  final String token;

  ImageUploadRequestModel({
    required this.image,
    required this.token,
  });
}
