import '../../data/model/create_tute/create__tute_response_model.dart';
import '../../data/model/create_tute/create_tute_request_model.dart';
import '../repository/tute_repository.dart';

class CreateTuteUseCase {
  final TuteRepository repository;

  CreateTuteUseCase(this.repository);

  Future<CreateTuteResponseModel> call({
    required String token,
    required int studentId,
    required int classCategoryHasStudentClassId,
    required int year,
    required int month,
  }) {
    final request = CreateTuteRequestModel(
      studentId: studentId,
      classCategoryHasStudentClassId: classCategoryHasStudentClassId,
      year: year,
      month: month,
    );

    return repository.createTute(token, request);
  }
}
