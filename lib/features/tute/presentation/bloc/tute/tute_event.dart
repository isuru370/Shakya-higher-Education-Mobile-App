part of 'tute_bloc.dart';

sealed class TuteEvent extends Equatable {
  const TuteEvent();

  @override
  List<Object> get props => [];
}

final class LoadAllTuteEvent extends TuteEvent {
  final String token;
  final int studentId;
  final int classCategoryStudentClassId;

  const LoadAllTuteEvent({
    required this.token,
    required this.studentId,
    required this.classCategoryStudentClassId,
  });

  @override
  List<Object> get props => [token, studentId, classCategoryStudentClassId];
}

final class CreateTuteEvent extends TuteEvent {
  final String token;
  final int studentId;
  final int classCategoryHasStudentClassId;
  final int year;
  final int month;

  const CreateTuteEvent({
    required this.token,
    required this.studentId,
    required this.classCategoryHasStudentClassId,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [token, studentId, classCategoryHasStudentClassId, year, month];
}

final class ToggleStatusTuteEvent extends TuteEvent {
  final String token;
  final int tuteId;

  const ToggleStatusTuteEvent({
    required this.token,
    required this.tuteId,
  });

  @override
  List<Object> get props => [token, tuteId];
}
