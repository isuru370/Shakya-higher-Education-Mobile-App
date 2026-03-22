part of 'student_classes_bloc.dart';

sealed class StudentClassesEvent extends Equatable {
  const StudentClassesEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch student classes
final class FetchStudentClasses extends StudentClassesEvent {
  final int studentId;
  final String token;

  const FetchStudentClasses({required this.studentId, required this.token});

  @override
  List<Object?> get props => [studentId, token];
}

final class ChangeStudentClassStatus extends StudentClassesEvent {
  final ClassStatusRequestModel classStatusRequest;
  final int studentId;

  const ChangeStudentClassStatus({
    required this.classStatusRequest,
    required this.studentId,
  });

  @override
  List<Object?> get props => [classStatusRequest, studentId];
}

final class SubmitCreateStudentClass extends StudentClassesEvent {
  final CreateStudentClassRequestModel request;

  const SubmitCreateStudentClass({required this.request});

  @override
  List<Object?> get props => [request];
}
