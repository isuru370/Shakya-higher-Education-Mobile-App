import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/mark_payment_request_model.dart';
import '../../../data/models/mark_payment_response_model.dart';
import '../../../domain/usecases/mark_payment_usecase.dart';

part 'mark_payment_event.dart';
part 'mark_payment_state.dart';

class MarkPaymentBloc extends Bloc<MarkPaymentEvent, MarkPaymentState> {
  final MarkPaymentUseCase markPaymentUseCase;

  MarkPaymentBloc({required this.markPaymentUseCase})
      : super(MarkPaymentInitial()) {
    on<MarkPaymentEvent>((event, emit) async {
      if (event is MarkPaymentRequested) {
        emit(MarkPaymentLoading());

        try {
          final response = await markPaymentUseCase.call(
            token: event.token,
            requestModel: event.requestModel,
          );

          emit(MarkPaymentLoaded(response: response));
        } catch (e) {
          // Extract API error message if possible
          String errorMessage = 'Failed to mark payment';
          if (e is Exception) {
            final msg = e.toString();

            // Look for "message" key in the API JSON error
            final regex = RegExp(r'"message"\s*:\s*"([^"]+)"');
            final match = regex.firstMatch(msg);
            if (match != null) errorMessage = match.group(1)!;
          }

          emit(MarkPaymentError(message: errorMessage));
        }
      }
    });
  }
}
