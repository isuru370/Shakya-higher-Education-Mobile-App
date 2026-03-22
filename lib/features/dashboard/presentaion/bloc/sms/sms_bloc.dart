import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/sms/sms_response_model.dart';
import '../../../domain/usecases/sms_balance_usecase.dart';


part 'sms_event.dart';
part 'sms_state.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final SmsBalanceUseCase smsBalanceUseCase;

  SmsBloc({required this.smsBalanceUseCase}) : super(SmsInitial()) {
    on<GetSmsBalanceEvent>(_onGetSmsBalance);
  }

  Future<void> _onGetSmsBalance(
    GetSmsBalanceEvent event,
    Emitter<SmsState> emit,
  ) async {
    emit(SmsLoading());

    try {
      final result = await smsBalanceUseCase(token: event.token);

      emit(SmsLoaded(result));
    } catch (e) {
      emit(SmsError(e.toString()));
    }
  }
}