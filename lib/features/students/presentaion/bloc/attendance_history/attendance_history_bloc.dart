import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../../data/models/attendance_history/attendance_history_response_model.dart';
import '../../../domain/usecases/attendance_history_usecase.dart';

part 'attendance_history_event.dart';
part 'attendance_history_state.dart';

class AttendanceHistoryBloc
    extends Bloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  final AttendanceHistoryUseCase attendanceHistoryUseCase;

  AttendanceHistoryBloc({required this.attendanceHistoryUseCase})
    : super(AttendanceHistoryInitial()) {
    on<FetchAttendanceHistory>(_onFetchAttendanceHistory);
  }

  Future<void> _onFetchAttendanceHistory(
    FetchAttendanceHistory event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    emit(AttendanceHistoryLoading());

    try {
      final request = AttendanceHistoryRequestModel(
        studentId: event.studentId,
        classCategoryHasStudentClassId: event.classCategoryHasStudentClassId,
        token: event.token,
      );

      final response = await attendanceHistoryUseCase.execute(request);
      emit(AttendanceHistoryLoaded(response));
    } catch (e) {
      emit(AttendanceHistoryError(e.toString()));
    }
  }
}
