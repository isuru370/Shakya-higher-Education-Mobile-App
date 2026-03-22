class FetchQuickPhotoRequestModel {
  final String token;
  final String quickImageId;

  const FetchQuickPhotoRequestModel({
    required this.token,
    required this.quickImageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'quick_image_id': quickImageId,
    };
  }
}