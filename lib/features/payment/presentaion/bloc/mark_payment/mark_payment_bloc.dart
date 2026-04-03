import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/bulk_mark_payment_request_model.dart.dart';
import '../../../data/models/mark_payment_request_model.dart';
import '../../../data/models/mark_payment_response_model.dart';
import '../../../domain/usecases/mark_payment_usecase.dart';

part 'mark_payment_event.dart';
part 'mark_payment_state.dart';

class MarkPaymentBloc extends Bloc<MarkPaymentEvent, MarkPaymentState> {
  final MarkPaymentUseCase markPaymentUseCase;

  MarkPaymentBloc({required this.markPaymentUseCase})
      : super(MarkPaymentInitial()) {
    on<MarkPaymentRequested>(_onMarkPaymentRequested);
    on<MarkBulkPaymentRequested>(_onMarkBulkPaymentRequested);
  }

  Future<void> _onMarkPaymentRequested(
    MarkPaymentRequested event,
    Emitter<MarkPaymentState> emit,
  ) async {
    emit(MarkPaymentLoading());

    try {
      final response = await markPaymentUseCase.call(
        token: event.token,
        requestModel: event.requestModel,
      );

      emit(MarkPaymentLoaded(response: response));
    } catch (e) {
      emit(MarkPaymentError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> _onMarkBulkPaymentRequested(
    MarkBulkPaymentRequested event,
    Emitter<MarkPaymentState> emit,
  ) async {
    emit(MarkPaymentLoading());

    try {
      final response = await markPaymentUseCase.bulk(
        token: event.token,
        requestModel: event.requestModel,
      );

      emit(MarkPaymentLoaded(response: response));
    } catch (e) {
      emit(MarkPaymentError(message: _extractErrorMessage(e)));
    }
  }

  String _extractErrorMessage(Object e) {
    String errorMessage = 'Failed to mark payment';

    final msg = e.toString();
    final regex = RegExp(r'"message"\s*:\s*"([^"]+)"');
    final match = regex.firstMatch(msg);

    if (match != null) {
      errorMessage = match.group(1)!;
    }

    return errorMessage;
  }
}