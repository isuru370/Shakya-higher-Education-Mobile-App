part of 'attendance_history_bloc.dart';

abstract class AttendanceHistoryEvent extends Equatable {
  const AttendanceHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchAttendanceHistory extends AttendanceHistoryEvent {
  final int studentId;
  final int classCategoryHasStudentClassId;
  final String token;

  const FetchAttendanceHistory({
    required this.studentId,
    required this.classCategoryHasStudentClassId,
    required this.token,
  });

  @override
  List<Object?> get props => [studentId, classCategoryHasStudentClassId, token];
}
