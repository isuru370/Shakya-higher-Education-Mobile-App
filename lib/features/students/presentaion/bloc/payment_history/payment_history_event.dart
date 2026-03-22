part of 'payment_history_bloc.dart';

sealed class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object> get props => [];
}

// Event: fetch payment history for a student
final class FetchPaymentHistory extends PaymentHistoryEvent {
  final int studentId;
  final int studentStudentStudentClassId;
  final String token;

  const FetchPaymentHistory({
    required this.studentId,
    required this.studentStudentStudentClassId,
    required this.token,
  });

  @override
  List<Object> get props => [studentId, studentStudentStudentClassId, token];
}
