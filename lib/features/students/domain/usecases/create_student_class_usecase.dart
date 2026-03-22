

import '../../data/models/student_classes_model/create_student_request_class_model.dart';
import '../../data/models/student_classes_model/create_student_response__class_model.dart';
import '../repositories/student_classes_repository.dart';

class CreateStudentClassUseCase {
  final StudentClassesRepository repository;

  CreateStudentClassUseCase(this.repository);

  Future<CreateStudentClassResponseModel> execute(
    CreateStudentClassRequestModel request,
  ) {
    return repository.createStudentClass(request);
  }
}