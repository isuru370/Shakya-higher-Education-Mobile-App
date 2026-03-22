class MarkPaymentRequestModel {
  final String paymentDate;
  final bool status;
  final int amount;
  final int studentId;
  final int studentStudentClassId;
  final String paymentFor;
    final String guardianMobile;

  MarkPaymentRequestModel({
    required this.paymentDate,
    required this.status,
    required this.amount,
    required this.studentId,
    required this.studentStudentClassId,
    required this.paymentFor,
    required this.guardianMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_date': paymentDate,
      'status': status,
      'amount': amount,
      'student_id': studentId,
      'student_student_student_classes_id': studentStudentClassId,
      'payment_for': paymentFor,
      'guardian_mobile' : guardianMobile,
    };
  }
}
