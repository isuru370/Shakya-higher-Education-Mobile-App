import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/activated_tem_qr_response_model.dart';
import '../../../data/model/activated_temp_qr_request_model.dart';
import '../../../data/model/student_temp_qr_model.dart';
import '../../../data/model/student_temp_qr_request_model.dart';
import '../../../domain/usecase/activeted_temp_qr_code_usecase.dart';
import '../../../domain/usecase/fetch_student_temp_qr_usecase.dart';

part 'temp_qr_event.dart';
part 'temp_qr_state.dart';

class TempQrBloc extends Bloc<TempQrEvent, TempQrState> {
  final FetchStudentTempQrUseCase fetchStudentTempQrUseCase;
  final ActivatedTempQrCodeUseCase activatedTempQrCodeUseCase;

  TempQrBloc({
    required this.fetchStudentTempQrUseCase,
    required this.activatedTempQrCodeUseCase,
  }) : super(TempQrInitial()) {
    on<FetchTempQrEvent>(_onFetchTempQr);
    on<ActivatedTempQrEvent>(_onActivatedTempQr);
  }

  Future<void> _onFetchTempQr(
    FetchTempQrEvent event,
    Emitter<TempQrState> emit,
  ) async {
    emit(TempQrLoading());

    try {
      final requestModel = StudentTempQrRequestModel(
        token: event.token,
        search: event.search,
      );

      final qrList = await fetchStudentTempQrUseCase.call(requestModel);

      emit(TempQrLoaded(qrList: qrList));
    } catch (e) {
      emit(TempQrError(message: e.toString()));
    }
  }

  Future<void> _onActivatedTempQr(
    ActivatedTempQrEvent event,
    Emitter<TempQrState> emit,
  ) async {
    emit(TempQrLoading());

    try {
      final requestModel = ActivatedTempQrRequestModel(
        token: event.token,
        customId: event.customId,
      );

      final activated = await activatedTempQrCodeUseCase.call(requestModel);
      emit(ActivatedTempQrLoaded(activatedQr: activated));
    } catch (e) {
      emit(TempQrError(message: e.toString()));
    }
  }
}
