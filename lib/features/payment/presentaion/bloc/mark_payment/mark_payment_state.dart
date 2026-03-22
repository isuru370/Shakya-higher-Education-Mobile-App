part of 'mark_payment_bloc.dart';

abstract class MarkPaymentState extends Equatable {
  const MarkPaymentState();

  @override
  List<Object> get props => [];
}

class MarkPaymentInitial extends MarkPaymentState {}

class MarkPaymentLoading extends MarkPaymentState {}

class MarkPaymentLoaded extends MarkPaymentState {
  final MarkPaymentResponseModel response;

  const MarkPaymentLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class MarkPaymentError extends MarkPaymentState {
  final String message;

  const MarkPaymentError({required this.message});

  @override
  List<Object> get props => [message];
}