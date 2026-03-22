part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceRequested extends AttendanceEvent {
  final String token;
  final int studentId;
  final int studentClassId;
  final int attendanceId;
  final int classCategoryHasStudentClassId;
  final bool tute;
  final String guardianMobile;

  const MarkAttendanceRequested({
    required this.token,
    required this.studentId,
    required this.studentClassId,
    required this.attendanceId,
    required this.classCategoryHasStudentClassId,
    required this.tute,
    required this.guardianMobile,
  });

  @override
  List<Object?> get props => [
    token,
    studentId,
    studentClassId,
    attendanceId,
    classCategoryHasStudentClassId,
    tute,
    guardianMobile,
  ];
}
