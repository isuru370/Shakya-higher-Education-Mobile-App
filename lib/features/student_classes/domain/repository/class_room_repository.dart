import '../../data/models/get_classes_by_grade_response_model.dart';

abstract class ClassRoomRepository {
  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required String token,
    required String gradeId,
  });
}