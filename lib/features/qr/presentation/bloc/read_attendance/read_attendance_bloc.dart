import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/read_attendance/read_attendance_model.dart';
import '../../../domain/usecases/read_attendance_usecase.dart';

part 'read_attendance_event.dart';
part 'read_attendance_state.dart';

class ReadAttendanceBloc extends Bloc<ReadAttendanceEvent, ReadAttendanceState> {
  final ReadAttendanceUseCase readAttendanceUseCase;

  ReadAttendanceBloc({required this.readAttendanceUseCase})
      : super(ReadAttendanceInitial()) {
    on<ReadAttendanceRequested>(_onReadAttendanceRequested);
  }

  Future<void> _onReadAttendanceRequested(
      ReadAttendanceRequested event, Emitter<ReadAttendanceState> emit) async {
    emit(ReadAttendanceLoading());

    try {
      final result = await readAttendanceUseCase(event.token, event.customId);
      emit(ReadAttendanceLoaded(
        attendanceList: result.data,
        studentId: result.studentId,
      ));
    } catch (e) {
      emit(ReadAttendanceError(e.toString()));
    }
  }
}
