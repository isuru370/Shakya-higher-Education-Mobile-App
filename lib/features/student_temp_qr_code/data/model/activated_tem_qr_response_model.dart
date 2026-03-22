class ActivatedTemQrResponseModel {
  final String status;
  final String message;
  final int? studentId;

  ActivatedTemQrResponseModel({
    required this.status,
    required this.message,
    this.studentId,
  });

  factory ActivatedTemQrResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivatedTemQrResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      studentId: json['student_id'],
    );
  }
}
