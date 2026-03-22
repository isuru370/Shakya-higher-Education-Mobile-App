import '../../data/model/fetch_tute/tute_response_model.dart';
import '../repository/tute_repository.dart';

class GetAllTuteUseCase {
  final TuteRepository repository;

  GetAllTuteUseCase(this.repository);

  Future<TuteResponseModel> call(
    String token,
    int studentId,
    int classCategoryStudentClassId,
  ) {
    return repository.getAllTutes(
      token,
      studentId,
      classCategoryStudentClassId,
    );
  }
}