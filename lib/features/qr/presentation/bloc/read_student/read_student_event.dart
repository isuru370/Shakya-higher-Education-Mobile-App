part of 'read_student_bloc.dart';

sealed class ReadStudentEvent extends Equatable {
  const ReadStudentEvent();

  @override
  List<Object> get props => [];
}
class ReadStudentRequested extends ReadStudentEvent {
  final String token;
  final String customId;

  const ReadStudentRequested({
    required this.token,
    required this.customId,
  });

  @override
  List<Object> get props => [token, customId];
}