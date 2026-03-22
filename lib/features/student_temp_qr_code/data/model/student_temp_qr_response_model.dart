import 'student_temp_qr_model.dart';

class StudentTempQrResponseModel {
  final List<StudentTempQrModel> temporaryQrs;

  StudentTempQrResponseModel({required this.temporaryQrs});

  factory StudentTempQrResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['temporary_qrs'] as List? ?? [];
    final qrList = data.map((e) => StudentTempQrModel.fromJson(e)).toList();
    return StudentTempQrResponseModel(temporaryQrs: qrList);
  }
}
