part of 'temp_qr_bloc.dart';

sealed class TempQrState extends Equatable {
  const TempQrState();

  @override
  List<Object?> get props => [];
}

// Initial state
final class TempQrInitial extends TempQrState {}

// Loading state
final class TempQrLoading extends TempQrState {}

// Loaded state with list of temp QR models
final class TempQrLoaded extends TempQrState {
  final List<StudentTempQrModel> qrList;

  const TempQrLoaded({required this.qrList});

  @override
  List<Object?> get props => [qrList];
}

final class ActivatedTempQrLoaded extends TempQrState {
  final ActivatedTemQrResponseModel activatedQr;

  const ActivatedTempQrLoaded({required this.activatedQr});

  @override
  List<Object?> get props => [activatedQr];
}

// Error state
final class TempQrError extends TempQrState {
  final String message;

  const TempQrError({required this.message});

  @override
  List<Object?> get props => [message];
}
