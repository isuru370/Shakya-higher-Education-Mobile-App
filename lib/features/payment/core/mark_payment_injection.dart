import 'package:get_it/get_it.dart';

import '../data/datasources/mark_payment_remote_data_source.dart';
import '../data/repositories/mark_payment_repository_Impl.dart';
import '../domain/repositories/mark_payment_repository.dart';
import '../domain/usecases/mark_payment_usecase.dart';
import '../presentaion/bloc/mark_payment/mark_payment_bloc.dart';

final sl = GetIt.instance;

Future<void> initMarkPaymentDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => MarkPaymentRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<MarkPaymentRepository>(
    () => MarkPaymentRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => MarkPaymentUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => MarkPaymentBloc(markPaymentUseCase: sl()));
}
