import 'package:get_it/get_it.dart';

import '../data/datasources/get_classes_by_grade_remote_datasource.dart';
import '../data/repository/class_room_repository_impl.dart';
import '../domain/repository/class_room_repository.dart';
import '../domain/usecase/get_classes_by_grade_usecase.dart';
import '../presentaion/bloc/class_room/class_room_bloc.dart';

final sl = GetIt.instance;

Future<void> initClassRoomDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => GetClassesByGradeRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ClassRoomRepository>(
    () => ClassRoomRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => GetClassesByGradeUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ClassRoomBloc(getClassesByGradeUsecase: sl()));
}
