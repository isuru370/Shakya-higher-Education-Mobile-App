import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/get_classes_by_grade_response_model.dart';
import '../../../domain/usecase/get_classes_by_grade_usecase.dart';

part 'class_room_event.dart';
part 'class_room_state.dart';

class ClassRoomBloc extends Bloc<ClassRoomEvent, ClassRoomState> {
  final GetClassesByGradeUseCase getClassesByGradeUsecase;

  ClassRoomBloc({
    required this.getClassesByGradeUsecase,
  }) : super(ClassRoomInitial()) {

    on<LoadClassesByGradeEvent>((event, emit) async {
      emit(ClassRoomLoading());

      try {
        final result = await getClassesByGradeUsecase(
          token: event.token,
          gradeId: event.gradeId,
        );

        emit(ClassRoomLoaded(result));
      } catch (e) {
        emit(ClassRoomError(e.toString()));
      }
    });

  }
}