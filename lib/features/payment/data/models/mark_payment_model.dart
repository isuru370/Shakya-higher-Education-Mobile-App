class MarkPaymentModel {
  final int id;
  final DateTime paymentDate;
  final int status;
  final int amount;
  final int studentId;
  final int studentStudentClassId;
  final String paymentFor;

  final DateTime createdAt;
  final DateTime updatedAt;

  MarkPaymentModel({
    required this.id,
    required this.paymentDate,
    required this.status,
    required this.amount,
    required this.studentId,
    required this.studentStudentClassId,
    required this.paymentFor,

    required this.createdAt,
    required this.updatedAt,
  });

  factory MarkPaymentModel.fromJson(Map<String, dynamic> json) {
    return MarkPaymentModel(
      id: json['id'],
      paymentDate: DateTime.parse(json['payment_date']),
      status: json['status'],
      amount: json['amount'],
      studentId: json['student_id'],
      studentStudentClassId: json['student_student_student_classes_id'],
      paymentFor: json['payment_for'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
