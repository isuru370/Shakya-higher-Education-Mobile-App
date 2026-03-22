class ImageUploadResponseModel {
  final String status;
  final String imageUrl;
  final String message;

  ImageUploadResponseModel({
    required this.status,
    required this.imageUrl,
    required this.message,
  });

  factory ImageUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponseModel(
      status: json["status"],
      imageUrl: json["image_url"],
      message: json["message"],
    );
  }
}
