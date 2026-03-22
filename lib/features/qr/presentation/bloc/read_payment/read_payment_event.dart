part of 'read_payment_bloc.dart';

sealed class ReadPaymentEvent extends Equatable {
  const ReadPaymentEvent();

  @override
  List<Object> get props => [];
}

class ReadPaymentRequested extends ReadPaymentEvent {
  final String token;
  final String customId;

  const ReadPaymentRequested({
    required this.token,
    required this.customId,
  });

  @override
  List<Object> get props => [token, customId];
}
