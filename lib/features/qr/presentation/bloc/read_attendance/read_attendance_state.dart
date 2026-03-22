part of 'read_attendance_bloc.dart';

sealed class ReadAttendanceState extends Equatable {
  const ReadAttendanceState();

  @override
  List<Object?> get props => [];
}

final class ReadAttendanceInitial extends ReadAttendanceState {}

final class ReadAttendanceLoading extends ReadAttendanceState {}

final class ReadAttendanceLoaded extends ReadAttendanceState {
  final List<ReadAttendanceModel> attendanceList;
  final int studentId;

  const ReadAttendanceLoaded({
    required this.attendanceList,
    required this.studentId,
  });

  @override
  List<Object?> get props => [attendanceList, studentId];
}

final class ReadAttendanceError extends ReadAttendanceState {
  final String message;

  const ReadAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
