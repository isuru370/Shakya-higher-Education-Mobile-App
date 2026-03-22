import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/atendance_request_model.dart';
import '../../../domain/usecases/mark_attendance_usecase.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final MarkAttendanceUseCase markAttendanceUseCase;

  AttendanceBloc({required this.markAttendanceUseCase})
    : super(AttendanceInitial()) {
    on<MarkAttendanceRequested>(_onMarkAttendanceRequested);
  }

  Future<void> _onMarkAttendanceRequested(
    MarkAttendanceRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    try {
      // Create request model
      final request = AttendanceRequestModel(
        studentId: event.studentId,
        studentStudentClassId: event.studentClassId,
        attendanceId: event.attendanceId,
        tute: event.tute,
        classCategoryHasStudentClassId: event.classCategoryHasStudentClassId,
        guardianMobile: event.guardianMobile,
      );

      // Call usecase
      final result = await markAttendanceUseCase(
        token: event.token,
        request: request,
      );

      // Emit success with full API response
      emit(
        AttendanceSuccess(
          message: result.message, // <-- Fixed
          attendanceMarked: result.attendanceMarked,
          tuteMarked: result.tuteMarked,
        ),
      );
    } catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }
}
