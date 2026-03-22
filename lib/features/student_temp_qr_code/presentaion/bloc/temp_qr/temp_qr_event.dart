part of 'temp_qr_bloc.dart';

sealed class TempQrEvent extends Equatable {
  const TempQrEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch temp QR codes
final class FetchTempQrEvent extends TempQrEvent {
  final String token;
  final String? search;

  const FetchTempQrEvent({required this.token, this.search});

  @override
  List<Object?> get props => [token, search];
}

final class ActivatedTempQrEvent extends TempQrEvent {
  final String token;
  final String? customId;

  const ActivatedTempQrEvent({required this.token, this.customId});

  @override
  List<Object?> get props => [token, customId];
}
