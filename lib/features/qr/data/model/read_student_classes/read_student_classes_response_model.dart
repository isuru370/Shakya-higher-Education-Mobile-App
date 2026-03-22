import 'read_student_classes_data_model.dart';

class ReadStudentClassesResponseModel {
  final String status;
  final String message;
  final ReadStudentClassesDataModel data;

  ReadStudentClassesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReadStudentClassesResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ReadStudentClassesResponseModel(
      status: json['status'],
      message: json['message'],
      data: ReadStudentClassesDataModel.fromJson(json['data']),
    );
  }
}