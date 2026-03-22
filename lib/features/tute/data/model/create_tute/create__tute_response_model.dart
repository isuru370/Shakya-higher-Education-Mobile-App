class CreateTuteResponseModel {
  final String status;
  final String message;

  CreateTuteResponseModel({
    required this.status,
    required this.message,
  });

  factory CreateTuteResponseModel.fromJson(
      Map<String, dynamic> json) {
    return CreateTuteResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}