import 'package:get_it/get_it.dart';

import '../data/datasources/student_temp_qr_remote_data_source.dart';
import '../data/repository/student_temp_qr_repository_impl.dart';
import '../domain/repository/student_temp_qr_repository.dart';
import '../domain/usecase/activeted_temp_qr_code_usecase.dart';
import '../domain/usecase/fetch_student_temp_qr_usecase.dart';
import '../presentaion/bloc/temp_qr/temp_qr_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudentTempQrDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => StudentTempQrRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<StudentTempQrRepository>(
    () => StudentTempQrRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => FetchStudentTempQrUseCase(sl()));
  sl.registerLazySingleton(() => ActivatedTempQrCodeUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => TempQrBloc(
      fetchStudentTempQrUseCase: sl(),
      activatedTempQrCodeUseCase: sl(),
    ),
  );
}
