import '../../data/model/tute_status/toggle_status_response_model.dart';
import '../../data/model/tute_status/toggle_status_tute_request_model.dart';
import '../repository/tute_repository.dart';

class ToggleStatusTuteUseCase {
  final TuteRepository repository;

  ToggleStatusTuteUseCase(this.repository);

  Future<ToggleStatusResponseModel> call({
    required String token,
    required ToggleStatusTuteRequestModel request,
  }) {
    return repository.toggleStatus(token, request);
  }
}
