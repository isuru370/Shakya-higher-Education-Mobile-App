part of 'read_attendance_bloc.dart';

sealed class ReadAttendanceEvent extends Equatable {
  const ReadAttendanceEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger fetching attendance
final class ReadAttendanceRequested extends ReadAttendanceEvent {
  final String token;
  final String customId;

  const ReadAttendanceRequested({
    required this.token,
    required this.customId,
  });

  @override
  List<Object?> get props => [token, customId];
}
