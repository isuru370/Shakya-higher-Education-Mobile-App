import '../../data/model/create_tute/create__tute_response_model.dart';
import '../../data/model/create_tute/create_tute_request_model.dart';
import '../../data/model/fetch_tute/tute_response_model.dart';
import '../../data/model/tute_status/toggle_status_response_model.dart';
import '../../data/model/tute_status/toggle_status_tute_request_model.dart';

abstract class TuteRepository {
  Future<TuteResponseModel> getAllTutes(
    String token,
    int studentId,
    int classCategoryStudentClassId,
  );

  Future<CreateTuteResponseModel> createTute(
    String token,
    CreateTuteRequestModel request,
  );

  Future<ToggleStatusResponseModel> toggleStatus(
    String token,
    ToggleStatusTuteRequestModel request,
  );
}
