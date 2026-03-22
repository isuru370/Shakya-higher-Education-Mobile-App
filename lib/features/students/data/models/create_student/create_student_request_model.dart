import '../students_model.dart';

class CreateStudentRequestModel {
  final String token;
  final List<StudentModel> students;

  CreateStudentRequestModel({required this.token, required this.students});
}