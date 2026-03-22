import 'package:get_it/get_it.dart';

import '../data/datasources/attendance_history_remote_datasource.dart';
import '../data/repositories/attendance_history_repository_impl.dart';
import '../domain/repositories/attendance_history_repository.dart';
import '../domain/usecases/attendance_history_usecase.dart';
import '../presentaion/bloc/attendance_history/attendance_history_bloc.dart';

final sl = GetIt.instance;

Future<void> initAttendanceHistoryDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => AttendanceHistoryRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<AttendanceHistoryRepository>(
    () => AttendanceHistoryRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => AttendanceHistoryUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => AttendanceHistoryBloc(attendanceHistoryUseCase: sl()),
  );
}
