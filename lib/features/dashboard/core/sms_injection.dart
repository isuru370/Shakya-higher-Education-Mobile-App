import 'package:get_it/get_it.dart';

import '../data/datasources/sms_remote_datasource.dart';
import '../data/repositories/sms_repository_impl.dart';
import '../domain/repositories/sms_repository.dart';
import '../domain/usecases/sms_balance_usecase.dart';
import '../presentaion/bloc/sms/sms_bloc.dart';

final sl = GetIt.instance;

Future<void> initSMSDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => SmsRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<SmsRepository>(() => SmsRepositoryImpl(sl()));

  // 🟢 USECASE
  sl.registerLazySingleton(() => SmsBalanceUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => SmsBloc(smsBalanceUseCase: sl()));
}
