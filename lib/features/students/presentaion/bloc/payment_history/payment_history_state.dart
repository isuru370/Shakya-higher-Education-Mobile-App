part of 'payment_history_bloc.dart';

sealed class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object> get props => [];
}

// initial state
final class PaymentHistoryInitial extends PaymentHistoryState {}

// loading state
final class PaymentHistoryLoading extends PaymentHistoryState {}

// loaded state
final class PaymentHistoryLoaded extends PaymentHistoryState {
  final PaymentHistoryResponseModel response;

  const PaymentHistoryLoaded(this.response);

  @override
  List<Object> get props => [response];
}

// error state
final class PaymentHistoryError extends PaymentHistoryState {
  final String message;

  const PaymentHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
