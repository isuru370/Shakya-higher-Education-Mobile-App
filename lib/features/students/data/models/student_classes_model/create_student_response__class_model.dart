class CreateStudentClassResponseModel {
  final String status;
  final String message;

  CreateStudentClassResponseModel({
    required this.status,
    required this.message,
  });

  factory CreateStudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentClassResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
