part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  final bool attendanceMarked;
  final bool tuteMarked;

  const AttendanceSuccess({
    required this.message,
    required this.attendanceMarked,
    required this.tuteMarked,
  });

  @override
  List<Object?> get props => [message, attendanceMarked, tuteMarked];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError({required this.message});
  @override
  List<Object?> get props => [message];
}
