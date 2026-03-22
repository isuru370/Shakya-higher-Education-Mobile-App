import 'package:get_it/get_it.dart';

import '../data/datasources/payment_history_remote_data_source.dart';
import '../data/repositories/payment_history_repository_Impl.dart';
import '../domain/repositories/payment_history_repository.dart';
import '../domain/usecases/payment_history_usecase.dart';
import '../presentaion/bloc/payment_history/payment_history_bloc.dart';

final sl = GetIt.instance;

Future<void> initPaymentHistoryDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => PaymentHistoryRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<PaymentHistoryRepository>(
    () => PaymentHistoryRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => PaymentHistoryUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => PaymentHistoryBloc(paymentHistoryUseCase: sl()));
}
