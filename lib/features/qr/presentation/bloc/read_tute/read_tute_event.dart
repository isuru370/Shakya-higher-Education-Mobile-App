part of 'read_tute_bloc.dart';

sealed class ReadTuteEvent extends Equatable {
  const ReadTuteEvent();

  @override
  List<Object> get props => [];
}

class ReadTuteRequested extends ReadTuteEvent {
  final String token;
  final String customId;

  const ReadTuteRequested({
    required this.token,
    required this.customId,
  });

  @override
  List<Object> get props => [token, customId];
}
