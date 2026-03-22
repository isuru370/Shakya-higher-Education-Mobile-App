part of 'students_bloc.dart';

sealed class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object> get props => [];
}

final class StudentsInitial extends StudentsState {}

final class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<StudentModel> students;

  const StudentsLoaded(this.students);

  @override
  List<Object> get props => [students];
}

class StudentCustomIdLoaded extends StudentsState {
  final List<StudentCustomIdModel> studentCustomIdModel;

  const StudentCustomIdLoaded(this.studentCustomIdModel);

  @override
  List<Object> get props => [studentCustomIdModel];
}

class StudentsCreated extends StudentsState {
  final StudentModel student;
  final String message;

  const StudentsCreated({required this.student, required this.message});

  @override
  List<Object> get props => [student, message];
}

final class StudentsError extends StudentsState {
  final String message;

  const StudentsError(this.message);

  @override
  List<Object> get props => [message];
}
