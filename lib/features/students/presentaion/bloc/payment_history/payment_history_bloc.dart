import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/payment_history/payment_history_request_model.dart';
import '../../../data/models/payment_history/payment_history_response_model.dart';
import '../../../domain/usecases/payment_history_usecase.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final PaymentHistoryUseCase paymentHistoryUseCase;

  PaymentHistoryBloc({required this.paymentHistoryUseCase})
    : super(PaymentHistoryInitial()) {
    on<FetchPaymentHistory>(_onFetchPaymentHistory);
  }

  Future<void> _onFetchPaymentHistory(
    FetchPaymentHistory event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(PaymentHistoryLoading());

    try {
      final request = PaymentHistoryRequestModel(
        studentId: event.studentId,
        studentStudentStudentClassId: event.studentStudentStudentClassId,
        token: event.token,
      );

      final response = await paymentHistoryUseCase.execute(request);

      emit(PaymentHistoryLoaded(response));
    } catch (e) {
      emit(PaymentHistoryError(e.toString()));
    }
  }
}
