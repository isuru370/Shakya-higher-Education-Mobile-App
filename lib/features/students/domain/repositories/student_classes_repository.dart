import '../../data/models/student_classes_model/class_status_request_model.dart';
import '../../data/models/student_classes_model/class_status_response_model.dart';
import '../../data/models/student_classes_model/create_student_request_class_model.dart';
import '../../data/models/student_classes_model/create_student_response__class_model.dart';
import '../../data/models/student_classes_model/student_class_response_model.dart';
import '../../data/models/student_classes_model/student_request_model.dart';

abstract class StudentClassesRepository {
  Future<StudentClassResponseModel> getStudentClasses(
    StudentRequestModel request,
  );
  Future<ClassStatusResponseModel> changeStudentClassStatus({
    required ClassStatusRequestModel request,
  });
  Future<CreateStudentClassResponseModel> createStudentClass(
    CreateStudentClassRequestModel request,
  );
}
