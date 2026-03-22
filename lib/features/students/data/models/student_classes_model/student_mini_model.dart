import '../../../../../core/constants/api_constants.dart';

class StudentMiniModel {
  final String studentCustomId;
  final String fullName;
  final String initialName;
  final String imgUrl;
  final String guardianMobile;
  final bool studentStatus;

  StudentMiniModel({
    required this.studentCustomId,
    required this.fullName,
    required this.initialName,
    required this.imgUrl,
    required this.guardianMobile,
    required this.studentStatus,
  });

  factory StudentMiniModel.fromJson(Map<String, dynamic> json) {
    return StudentMiniModel(
      studentCustomId: json['student_custom_id'],
      fullName: json['first_name'],
      initialName: json['last_name'],
      imgUrl: json['img_url'].toString().replaceFirst(
        'http://127.0.0.1:8000',
        ApiConstants.baseUrl,
      ),
      guardianMobile: json['guardian_mobile'],
      studentStatus: json['student_status'],
    );
  }
}
