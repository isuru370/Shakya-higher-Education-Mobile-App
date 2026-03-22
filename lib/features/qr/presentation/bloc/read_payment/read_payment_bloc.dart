import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/read_payment/read_payments_response_model.dart';
import '../../../domain/usecases/read_payment_usecase.dart';


part 'read_payment_event.dart';
part 'read_payment_state.dart';

class ReadPaymentBloc extends Bloc<ReadPaymentEvent, ReadPaymentState> {
  final ReadPaymentUseCase readPaymentUseCase;

  ReadPaymentBloc({
    required this.readPaymentUseCase,
  }) : super(ReadPaymentInitial()) {
    on<ReadPaymentRequested>(_onReadPaymentRequested);
  }

  Future<void> _onReadPaymentRequested(
    ReadPaymentRequested event,
    Emitter<ReadPaymentState> emit,
  ) async {
    emit(ReadPaymentLoading());

    try {
      final result = await readPaymentUseCase(
        token: event.token,
        customId: event.customId,
      );

      emit(ReadPaymentLoaded(result));
    } catch (e) {
      emit(ReadPaymentError(e.toString()));
    }
  }
}
