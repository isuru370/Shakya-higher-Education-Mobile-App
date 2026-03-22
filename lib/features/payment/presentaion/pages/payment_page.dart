import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../qr/presentation/bloc/read_payment/read_payment_bloc.dart';
import '../../data/models/mark_payment_request_model.dart';
import '../bloc/mark_payment/mark_payment_bloc.dart';

class PaymentPage extends StatefulWidget {
  final ReadPaymentLoaded paymentState;
  final String token;

  const PaymentPage({
    super.key,
    required this.paymentState,
    required this.token,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Map<int, String> selectedMonth = {}; // key: studentClassId
  final Map<int, int> selectedYear = {};
  final Map<int, TextEditingController> amountControllers = {};

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in amountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payments = widget.paymentState.response;

    if (payments.data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payments')),
        body: const Center(child: Text('No payments found')),
      );
    }

    return BlocListener<MarkPaymentBloc, MarkPaymentState>(
      listener: (context, state) {
        if (state is MarkPaymentLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Payment successful!'),
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.popUntil(
              context,
              (route) => route.settings.name == '/qr-scan',
            );
          });
        } else if (state is MarkPaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Student Payments')),
        body: ListView.builder(
          itemCount: payments.data.length,
          itemBuilder: (context, index) {
            final payment = payments.data[index];
            final student = payment.student;
            final studentClass = payment.studentClass;
            final category = payment.classCategory;
            final latestPayment = payment.latestPayment;

            // Initialize controllers & month/year
            amountControllers.putIfAbsent(
              studentClass.id,
              () => TextEditingController(text: category.fees.toString()),
            );
            selectedMonth.putIfAbsent(
              studentClass.id,
              () => _monthName(DateTime.now().month),
            );
            selectedYear.putIfAbsent(
              studentClass.id,
              () => DateTime.now().year,
            );

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- STUDENT INFO ----------------
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(student.imageUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.initialName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Custom ID: ${student.customId}'),
                              Text('Guardian: ${student.guardianMobile}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ---------------- CLASS BADGES ----------------
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _badge(
                          'Class: ${studentClass.className}',
                          Colors.blue.shade100,
                          Colors.blue,
                        ),
                        _badge(
                          'Category: ${category.categoryName}',
                          Colors.orange.shade100,
                          Colors.orange,
                        ),
                        _badge(
                          'Fees: ${payment.isFreeCard ? 'Free Card' : 'LKR ${category.fees}'}',
                          Colors.green.shade100,
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (!payment.isFreeCard)
                      if (latestPayment != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latest Payment:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Amount: LKR ${latestPayment.amount}'),
                            Text('Month: ${latestPayment.paymentForMonth}'),
                            Text(
                              'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(latestPayment.paymentDate).toLocal())}',
                            ),
                          ],
                        )
                      else
                        const Text('No payments made yet.'),
                    const SizedBox(height: 12),

                    // ---------------- PAY BUTTON ----------------
                    if (!payment.isFreeCard)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showMarkPaymentDialog(
                            context,
                            payment.studentStudentStudentClassesId,
                            student,
                            studentClass,
                            category,
                          ),
                          icon: const Icon(Icons.payment),
                          label: const Text('Mark Payment'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMarkPaymentDialog(
    BuildContext context,
    int studentStudentStudentClassId,
    dynamic student,
    dynamic studentClass,
    dynamic category,
  ) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final years = [
      DateTime.now().year - 1,
      DateTime.now().year,
      DateTime.now().year + 1,
    ];

    final amountController = TextEditingController(
      text: category.fees.toString(),
    );
    bool useDefaultFee = true;
    int selectedY = DateTime.now().year;
    String selectedM = _monthName(DateTime.now().month);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Class: ${studentClass.className}'),
                    Text('Category: ${category.categoryName}'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<int>(
                            value: selectedY,
                            items: years
                                .map(
                                  (y) => DropdownMenuItem(
                                    value: y,
                                    child: Text('$y'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedY = val!),
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedM,
                            items: months
                                .map(
                                  (m) => DropdownMenuItem(
                                    value: m,
                                    child: Text(m),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedM = val!),
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: useDefaultFee,
                          onChanged: (val) =>
                              setState(() => useDefaultFee = val!),
                        ),
                        const Text('Use default fee'),
                      ],
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      enabled: !useDefaultFee,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: 'LKR ',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final paymentRequest = MarkPaymentRequestModel(
                      paymentDate: DateTime.now().toIso8601String(),
                      status: true,
                      amount:
                          int.tryParse(amountController.text) ?? category.fees,
                      studentId: student.id,
                      studentStudentClassId: studentStudentStudentClassId,
                      paymentFor: '$selectedY $selectedM',
                      guardianMobile: student.guardianMobile,
                    );

                    context.read<MarkPaymentBloc>().add(
                      MarkPaymentRequested(
                        token: widget.token,
                        requestModel: paymentRequest,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Pay'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget _badge(String text, Color bgColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
  );
}

String _monthName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
}
