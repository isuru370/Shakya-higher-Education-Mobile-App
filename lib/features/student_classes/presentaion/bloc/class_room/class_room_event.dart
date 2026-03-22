part of 'class_room_bloc.dart';

sealed class ClassRoomEvent extends Equatable {
  const ClassRoomEvent();

  @override
  List<Object> get props => [];
}

class LoadClassesByGradeEvent extends ClassRoomEvent {
  final String token;
  final String gradeId;

  const LoadClassesByGradeEvent({
    required this.token,
    required this.gradeId,
  });

  @override
  List<Object> get props => [token, gradeId];
}