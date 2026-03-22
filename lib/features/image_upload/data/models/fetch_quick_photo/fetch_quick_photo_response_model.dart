class FetchQuickPhotoResponseModel {
  final String status;
  final int id;
  final String imageUrl;

  const FetchQuickPhotoResponseModel({
    required this.status,
    required this.id,
    required this.imageUrl,
  });

  factory FetchQuickPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchQuickPhotoResponseModel(
      status: json['status'],
      id: json['id'],
      imageUrl: json['img_url'],
    );
  }
}
