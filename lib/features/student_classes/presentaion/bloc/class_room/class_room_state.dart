part of 'class_room_bloc.dart';

sealed class ClassRoomState extends Equatable {
  const ClassRoomState();

  @override
  List<Object> get props => [];
}

final class ClassRoomInitial extends ClassRoomState {}

final class ClassRoomLoading extends ClassRoomState {}

final class ClassRoomLoaded extends ClassRoomState {
  final GetClassesByGradeResponseModel response;

  const ClassRoomLoaded(this.response);

  @override
  List<Object> get props => [response];
}

final class ClassRoomError extends ClassRoomState {
  final String message;

  const ClassRoomError(this.message);

  @override
  List<Object> get props => [message];
}
