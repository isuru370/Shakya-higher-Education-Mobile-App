part of 'sms_bloc.dart';

sealed class SmsState extends Equatable {
  const SmsState();

  @override
  List<Object> get props => [];
}

final class SmsInitial extends SmsState {}

final class SmsLoading extends SmsState {}

final class SmsLoaded extends SmsState {
  final SmsResponseModel response;

  const SmsLoaded(this.response);

  @override
  List<Object> get props => [response];
}

final class SmsError extends SmsState {
  final String message;

  const SmsError(this.message);

  @override
  List<Object> get props => [message];
}
