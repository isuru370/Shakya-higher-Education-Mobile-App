import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/payment_history/payment_history_bloc.dart';

class PaymentHistoryViewPage extends StatefulWidget {
  final int studentId;
  final int studentStudentClassId;
  final String token;

  const PaymentHistoryViewPage({
    super.key,
    required this.studentId,
    required this.studentStudentClassId,
    required this.token,
  });

  @override
  State<PaymentHistoryViewPage> createState() => _PaymentHistoryViewPageState();
}

class _PaymentHistoryViewPageState extends State<PaymentHistoryViewPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentHistoryBloc>().add(
      FetchPaymentHistory(
        studentId: widget.studentId,
        studentStudentStudentClassId: widget.studentStudentClassId,
        token: widget.token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
        builder: (context, state) {
          if (state is PaymentHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentHistoryLoaded) {
            final response = state.response;
            final monthlyView = response.monthlyView;
            final summary = response.summary;

            return Column(
              children: [
                // 🔹 Summary Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryCard(
                        'Total Paid',
                        summary.totalPaid.toStringAsFixed(2),
                        Colors.green,
                      ),
                      _summaryCard(
                        'Payments',
                        summary.totalPayments.toString(),
                        Colors.blue,
                      ),
                      _summaryCard(
                        'Active',
                        summary.activePayments.toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                // 🔹 Monthly Payment List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: monthlyView.length,
                    itemBuilder: (context, index) {
                      final month = monthlyView[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            '${month.month} • Total: LKR ${month.totalAmount.toStringAsFixed(2)} • Payments: ${month.paymentCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          children: month.payments.map((payment) {
                            // format date
                            final formattedDate = DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(DateTime.parse(payment.paymentDate));

                            return ListTile(
                              leading: const Icon(
                                Icons.payment,
                                color: Colors.blue,
                              ),
                              title: Text(payment.paymentFor),
                              subtitle: Text(formattedDate),
                              trailing: Text(
                                'LKR ${payment.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is PaymentHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
