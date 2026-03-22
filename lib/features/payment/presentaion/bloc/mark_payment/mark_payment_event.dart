part of 'mark_payment_bloc.dart';

abstract class MarkPaymentEvent extends Equatable {
  const MarkPaymentEvent();

  @override
  List<Object> get props => [];
}

class MarkPaymentRequested extends MarkPaymentEvent {
  final String token;
  final MarkPaymentRequestModel requestModel;

  const MarkPaymentRequested({required this.token, required this.requestModel});

  @override
  List<Object> get props => [token, requestModel];
}