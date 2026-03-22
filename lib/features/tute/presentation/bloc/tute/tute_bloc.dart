import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/fetch_tute/tute_model.dart';
import '../../../data/model/tute_status/toggle_status_tute_request_model.dart';
import '../../../domain/usecase/create_tute_usecase.dart';
import '../../../domain/usecase/get_tute_usecase.dart';
import '../../../domain/usecase/toggle_tute_status_usecase.dart';

part 'tute_event.dart';
part 'tute_state.dart';

class TuteBloc extends Bloc<TuteEvent, TuteState> {
  final GetAllTuteUseCase getAllTuteUseCase;
  final CreateTuteUseCase createTuteUseCase;
  final ToggleStatusTuteUseCase toggleStatusTuteUseCase;

  TuteBloc({
    required this.getAllTuteUseCase,
    required this.createTuteUseCase,
    required this.toggleStatusTuteUseCase,
  }) : super(TuteInitial()) {
    on<LoadAllTuteEvent>(_onLoadAllTute);
    on<CreateTuteEvent>(_onCreateTute);
    on<ToggleStatusTuteEvent>(_onToggleStatus);
  }

  Future<void> _onCreateTute(
    CreateTuteEvent event,
    Emitter<TuteState> emit,
  ) async {
    emit(TuteLoading());

    try {
      final response = await createTuteUseCase(
        token: event.token,
        studentId: event.studentId,
        classCategoryHasStudentClassId: event.classCategoryHasStudentClassId,
        year: event.year,
        month: event.month,
      );

      emit(TuteCreateSuccess(response.message));
    } catch (e) {
      emit(TuteError(e.toString()));
    }
  }

  Future<void> _onLoadAllTute(
    LoadAllTuteEvent event,
    Emitter<TuteState> emit,
  ) async {
    emit(TuteLoading());

    try {
      final response = await getAllTuteUseCase(
        event.token,
        event.studentId,
        event.classCategoryStudentClassId,
      );

      emit(TuteLoaded(response.data));
    } catch (e) {
      emit(TuteError(e.toString()));
    }
  }

  Future<void> _onToggleStatus(
    ToggleStatusTuteEvent event,
    Emitter<TuteState> emit,
  ) async {
    emit(TuteLoading());

    try {
      final response = await toggleStatusTuteUseCase(
        token: event.token,
        request: ToggleStatusTuteRequestModel(tuteId: event.tuteId),
      );

      emit(TuteToggleStatusSuccess(response.message));
    } catch (e) {
      emit(TuteError(e.toString()));
    }
  }
}
