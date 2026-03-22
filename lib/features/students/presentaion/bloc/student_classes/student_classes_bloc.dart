import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/student_classes_model/class_status_request_model.dart';
import '../../../data/models/student_classes_model/create_student_request_class_model.dart';
import '../../../data/models/student_classes_model/create_student_response__class_model.dart';
import '../../../data/models/student_classes_model/student_class_response_model.dart';
import '../../../data/models/student_classes_model/student_request_model.dart';
import '../../../domain/usecases/change_student_class_status_usecase.dart';
import '../../../domain/usecases/create_student_class_usecase.dart';
import '../../../domain/usecases/student_classes_usecase.dart';

part 'student_classes_event.dart';
part 'student_classes_state.dart';

class StudentClassesBloc
    extends Bloc<StudentClassesEvent, StudentClassesState> {
  final StudentClassesUsecase studentClassesUsecase;
  final ChangeStudentClassStatusUseCase changeStudentClassStatusUseCase;
  final CreateStudentClassUseCase createStudentClassUseCase;

  StudentClassesBloc({
    required this.studentClassesUsecase,
    required this.changeStudentClassStatusUseCase,
    required this.createStudentClassUseCase,
  }) : super(StudentClassesInitial()) {
    on<FetchStudentClasses>(_onFetchStudentClasses);
    on<ChangeStudentClassStatus>(_onChangeStudentClassStatus);
    on<SubmitCreateStudentClass>(_onSubmitCreateStudentClass);
  }

  Future<void> _onFetchStudentClasses(
    FetchStudentClasses event,
    Emitter<StudentClassesState> emit,
  ) async {
    emit(StudentClassesLoading());

    try {
      final request = StudentRequestModel(
        studentId: event.studentId,
        token: event.token,
      );

      // Use the usecase instead of calling repository directly
      final response = await studentClassesUsecase.execute(request);

      emit(StudentClassesLoaded(response: response));
    } catch (e) {
      emit(StudentClassesError(e.toString()));
    }
  }

  Future<void> _onChangeStudentClassStatus(
    ChangeStudentClassStatus event,
    Emitter<StudentClassesState> emit,
  ) async {
    emit(StudentClassesLoading());
    try {
      final response = await changeStudentClassStatusUseCase.execute(
        request: event.classStatusRequest,
      );

      emit(StudentClassStatusChanged(response.message));
    } catch (e) {
      emit(StudentClassesError(e.toString()));
    }
  }

  Future<void> _onSubmitCreateStudentClass(
    SubmitCreateStudentClass event,
    Emitter<StudentClassesState> emit,
  ) async {
    emit(StudentClassesLoading());

    try {
      final response = await createStudentClassUseCase.execute(event.request);

      if (response.status == 'error') {
        emit(StudentClassesError(response.message));
      } else {
        emit(CreateStudentClassSuccess(response: response));
      }
    } catch (e) {
      emit(StudentClassesError(e.toString()));
    }
  }
}
