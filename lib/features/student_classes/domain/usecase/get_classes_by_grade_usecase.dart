import '../../data/models/get_classes_by_grade_response_model.dart';
import '../repository/class_room_repository.dart';

class GetClassesByGradeUseCase {
  final ClassRoomRepository repository;

  GetClassesByGradeUseCase(
     this.repository,
  );

  Future<GetClassesByGradeResponseModel> call({
    required String token,
    required String gradeId,
  }) {
    return repository.getClassesByGrade(
      token: token,
      gradeId: gradeId,
    );
  }
}