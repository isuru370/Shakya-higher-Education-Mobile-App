part of 'read_payment_bloc.dart';

sealed class ReadPaymentState extends Equatable {
  const ReadPaymentState();

  @override
  List<Object> get props => [];
}

final class ReadPaymentInitial extends ReadPaymentState {}

final class ReadPaymentLoading extends ReadPaymentState {}

final class ReadPaymentLoaded extends ReadPaymentState {
  final ReadPaymentResponseModel response;

  const ReadPaymentLoaded(this.response);

  @override
  List<Object> get props => [response];
}

final class ReadPaymentError extends ReadPaymentState {
  final String message;

  const ReadPaymentError(this.message);

  @override
  List<Object> get props => [message];
}
