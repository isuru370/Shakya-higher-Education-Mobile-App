part of 'sms_bloc.dart';

sealed class SmsEvent extends Equatable {
  const SmsEvent();

  @override
  List<Object> get props => [];
}

// Load SMS Balance
class GetSmsBalanceEvent extends SmsEvent {
  final String token;

  const GetSmsBalanceEvent({required this.token});

  @override
  List<Object> get props => [token];
}