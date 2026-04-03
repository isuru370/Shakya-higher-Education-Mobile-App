import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/printer_service.dart';
import '../../../qr/presentation/bloc/read_payment/read_payment_bloc.dart';
import '../../data/models/bulk_mark_payment_request_model.dart.dart';
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
  final PrinterService _printerService = PrinterService();

  dynamic _lastRequestedPayment;
  int _lastPaidAmount = 0;
  String _lastPaymentFor = '';

  final Set<int> _selectedPaymentIds = {};
  bool _isBulkMode = false;
  List<dynamic> _lastRequestedBulkPayments = [];

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedPaymentIds.contains(id)) {
        _selectedPaymentIds.remove(id);
      } else {
        _selectedPaymentIds.add(id);
      }
      _isBulkMode = _selectedPaymentIds.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPaymentIds.clear();
      _isBulkMode = false;
      _lastRequestedBulkPayments = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final payments = widget.paymentState.response;

    if (payments.data.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payments'),
          actions: [
            IconButton(icon: const Icon(Icons.print), onPressed: _printTest),
          ],
        ),
        body: const Center(child: Text('No payments found')),
      );
    }

    return BlocListener<MarkPaymentBloc, MarkPaymentState>(
      listener: (context, state) async {
        if (state is MarkPaymentLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                _lastRequestedBulkPayments.isNotEmpty
                    ? 'Bulk payment successful!'
                    : 'Payment successful!',
              ),
            ),
          );

          if (_lastRequestedBulkPayments.isNotEmpty) {
            // await _printBulkReceipt(
            //   payments: _lastRequestedBulkPayments,
            //   paymentFor: _lastPaymentFor,
            // );
          } else if (_lastRequestedPayment != null) {
            // await _printReceipt(
            //   payment: _lastRequestedPayment,
            //   paidAmount: _lastPaidAmount,
            //   paymentFor: _lastPaymentFor,
            // );
          }

          _lastRequestedPayment = null;
          _lastPaidAmount = 0;
          _lastPaymentFor = '';
          _lastRequestedBulkPayments = [];
          _clearSelection();

          if (!mounted) return;

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
        appBar: AppBar(
          title: Text(
            _isBulkMode
                ? 'Selected ${_selectedPaymentIds.length}'
                : 'Student Payments',
          ),
          actions: [
            IconButton(icon: const Icon(Icons.print), onPressed: _printTest),
            if (_selectedPaymentIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.payments),
                onPressed: () => _showBulkPaymentDialog(context, payments.data),
              ),
            if (_selectedPaymentIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSelection,
              ),
          ],
        ),
        body: ListView.builder(
          itemCount: payments.data.length,
          itemBuilder: (context, index) {
            final payment = payments.data[index];
            final student = payment.student;
            final studentClass = payment.studentClass;
            final category = payment.classCategory;
            final latestPayment = payment.latestPayment;

            final bool isInactive = !payment.status;
            final bool isFreeCard = payment.isFreeCard;
            final double payableAmount = payment.finalFee;
            final double defaultAmount = payment.defaultFee;

            final int selectionId = payment.studentStudentStudentClassesId;
            final bool isSelected = _selectedPaymentIds.contains(selectionId);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Opacity(
                opacity: isInactive ? 0.7 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (isInactive || isFreeCard)
                                ? null
                                : (_) => _toggleSelection(selectionId),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Select',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
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
                          if (studentClass.grade != null &&
                              studentClass.grade!.isNotEmpty)
                            _badge(
                              'Grade: ${studentClass.grade}',
                              Colors.purple.shade100,
                              Colors.purple,
                            ),
                          if (studentClass.subject != null &&
                              studentClass.subject!.isNotEmpty)
                            _badge(
                              'Subject: ${studentClass.subject}',
                              Colors.teal.shade100,
                              Colors.teal,
                            ),
                          _badge(
                            isFreeCard
                                ? 'Free Card'
                                : 'Payable: LKR ${payableAmount.toStringAsFixed(0)}',
                            Colors.green.shade100,
                            Colors.green,
                          ),
                          if (!isFreeCard)
                            _badge(
                              'Default: LKR ${defaultAmount.toStringAsFixed(0)}',
                              Colors.grey.shade200,
                              Colors.black87,
                            ),
                          if (!isFreeCard && payment.feeType.trim().isNotEmpty)
                            _badge(
                              payment.feeType,
                              Colors.amber.shade100,
                              Colors.brown,
                            ),
                          if (isInactive)
                            _badge(
                              payment.inactiveText,
                              Colors.red.shade100,
                              Colors.red,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!isFreeCard) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fee Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Default Fee: LKR ${payment.defaultFee.toStringAsFixed(0)}',
                              ),
                              if (payment.customFee != null)
                                Text(
                                  'Custom Fee: LKR ${payment.customFee!.toStringAsFixed(0)}',
                                ),
                              if (payment.discountPercentage != null &&
                                  payment.discountPercentage!.isNotEmpty)
                                Text(
                                  'Discount: ${payment.discountPercentage}% (${payment.discountType ?? '-'})',
                                ),
                              Text(
                                'Final Fee: LKR ${payment.finalFee.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (!isFreeCard)
                        if (latestPayment != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Latest Payment:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Amount: LKR ${latestPayment.amount.toStringAsFixed(0)}',
                              ),
                              Text('Month: ${latestPayment.paymentForMonth}'),
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(latestPayment.paymentDate).toLocal())}',
                              ),
                            ],
                          )
                        else
                          const Text('No payments made yet.'),
                      const SizedBox(height: 12),
                      if (!isFreeCard)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isInactive
                                ? null
                                : () =>
                                      _showMarkPaymentDialog(context, payment),
                            icon: const Icon(Icons.payment),
                            label: Text(
                              isInactive
                                  ? 'Student/Class Inactive'
                                  : 'Mark Payment',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<int>> _buildReceiptData({
    required dynamic payment,
    required int paidAmount,
    required String paymentFor,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final student = payment.student;
    final studentClass = payment.studentClass;
    final category = payment.classCategory;

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

    List<int> bytes = [];

    bytes += generator.reset();

    bytes += generator.text(
      'Vision Academy Of Higher Education',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
      ),
      linesAfter: 1,
    );

    bytes += generator.text(
      'PAYMENT RECEIPT',
      styles: const PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'Date', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: formattedDate, width: 8),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Student', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: '${student.initialName}', width: 8),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Student ID',
        width: 4,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(text: '${student.customId}', width: 8),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Class', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: '${studentClass.className}', width: 8),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Category',
        width: 4,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(text: '${category.categoryName}', width: 8),
    ]);

    if (studentClass.grade != null &&
        studentClass.grade.toString().trim().isNotEmpty) {
      bytes += generator.row([
        PosColumn(text: 'Grade', width: 4, styles: const PosStyles(bold: true)),
        PosColumn(text: '${studentClass.grade}', width: 8),
      ]);
    }

    if (studentClass.subject != null &&
        studentClass.subject.toString().trim().isNotEmpty) {
      bytes += generator.row([
        PosColumn(
          text: 'Subject',
          width: 4,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(text: '${studentClass.subject}', width: 8),
      ]);
    }

    if (payment.feeType != null &&
        payment.feeType.toString().trim().isNotEmpty) {
      bytes += generator.row([
        PosColumn(
          text: 'Fee Type',
          width: 4,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(text: '${payment.feeType}', width: 8),
      ]);
    }

    bytes += generator.row([
      PosColumn(text: 'For', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: paymentFor, width: 8),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
        text: 'Amount',
        width: 5,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: 'LKR ${paidAmount.toString()}',
        width: 7,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.right,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.hr();

    bytes += generator.text(
      'edu.nexorait.lk',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text(
      'Contact: 0768971213',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  Future<List<int>> _buildBulkReceiptData({
    required List<dynamic> payments,
    required String paymentFor,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final totalAmount = payments.fold<int>(
      0,
      (sum, item) => sum + (item.finalFee as num).toInt(),
    );

    List<int> bytes = [];

    bytes += generator.reset();

    bytes += generator.text(
      'Vision Academy Of Higher Education',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
      ),
      linesAfter: 1,
    );

    bytes += generator.text(
      'BULK PAYMENT SUMMARY',
      styles: const PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'Date', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: formattedDate, width: 8),
    ]);

    bytes += generator.row([
      PosColumn(text: 'For', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: paymentFor, width: 8),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Count', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: '${payments.length}', width: 8),
    ]);

    bytes += generator.hr();

    for (final item in payments) {
      final student = item.student;
      final studentClass = item.studentClass;
      final amount = (item.finalFee as num).toInt();

      bytes += generator.text(
        '${student.initialName}',
        styles: const PosStyles(bold: true),
      );

      bytes += generator.text(
        'Class: ${studentClass.className}',
        styles: const PosStyles(),
      );

      bytes += generator.row([
        PosColumn(text: 'ID: ${student.customId}', width: 7),
        PosColumn(
          text: 'LKR $amount',
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      bytes += generator.hr(ch: '-');
    }

    bytes += generator.row([
      PosColumn(
        text: 'TOTAL',
        width: 5,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: 'LKR $totalAmount',
        width: 7,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.right,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.hr();

    bytes += generator.text(
      'edu.nexorait.lk',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text(
      'Contact: 0768971213',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  Future<void> _printReceipt({
    required dynamic payment,
    required int paidAmount,
    required String paymentFor,
  }) async {
    try {
      if (!_printerService.isConnected) {
        throw Exception('Printer not connected');
      }

      final bytes = await _buildReceiptData(
        payment: payment,
        paidAmount: paidAmount,
        paymentFor: paymentFor,
      );

      await _printerService.printData(bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Print failed: $e'),
        ),
      );
    }
  }

  Future<void> _printBulkReceipt({
    required List<dynamic> payments,
    required String paymentFor,
  }) async {
    try {
      if (!_printerService.isConnected) {
        throw Exception('Printer not connected');
      }

      final bytes = await _buildBulkReceiptData(
        payments: payments,
        paymentFor: paymentFor,
      );

      await _printerService.printData(bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Bulk print failed: $e'),
        ),
      );
    }
  }

  Future<void> _printTest() async {
    try {
      if (!_printerService.isConnected) {
        throw Exception('Printer not connected');
      }

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      List<int> bytes = [];

      bytes += generator.reset();

      bytes += generator.text(
        'Vision Academy Of Higher Education',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
        linesAfter: 1,
      );

      bytes += generator.text(
        'TEST PRINT',
        styles: const PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 1,
      );

      bytes += generator.hr();

      bytes += generator.text(
        'Printer working successfully!',
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator.text(
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator.feed(1);
      bytes += generator.hr();

      bytes += generator.text(
        'edu.nexorait.lk',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.text(
        'Contact: 0768971213',
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      await _printerService.printData(bytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Test print success'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Test print failed: $e'),
        ),
      );
    }
  }

  void _showBulkPaymentDialog(BuildContext context, List<dynamic> allPayments) {
    final selectedItems = allPayments.where((p) {
      return _selectedPaymentIds.contains(p.studentStudentStudentClassesId);
    }).toList();

    if (selectedItems.isEmpty) return;

    final months = const [
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

    int selectedY = DateTime.now().year;
    String selectedM = _monthName(DateTime.now().month);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            final total = selectedItems.fold<int>(
              0,
              (sum, item) => sum + (item.finalFee as num).toInt(),
            );

            return AlertDialog(
              title: const Text('Confirm Bulk Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Students: ${selectedItems.length}'),
                    const SizedBox(height: 8),
                    ...selectedItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '- ${item.student.initialName} (${item.studentClass.className}) '
                          'LKR ${item.finalFee.toInt()}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedY,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder(),
                            ),
                            items: years.map((y) {
                              return DropdownMenuItem<int>(
                                value: y,
                                child: Text('$y'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedY = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedM,
                            decoration: const InputDecoration(
                              labelText: 'Month',
                              border: OutlineInputBorder(),
                            ),
                            items: months.map((m) {
                              return DropdownMenuItem<String>(
                                value: m,
                                child: Text(m),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedM = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total: LKR $total',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final paymentFor = '$selectedY $selectedM';

                    final requests = selectedItems.map<MarkPaymentRequestModel>(
                      (item) {
                        return MarkPaymentRequestModel(
                          paymentDate: DateTime.now().toIso8601String(),
                          status: true,
                          amount: item.finalFee.toInt(),
                          studentId: item.student.id,
                          studentStudentClassId:
                              item.studentStudentStudentClassesId,
                          paymentFor: paymentFor,
                          guardianMobile: item.student.guardianMobile,
                        );
                      },
                    ).toList();

                    _lastRequestedBulkPayments = selectedItems;
                    _lastRequestedPayment = null;
                    _lastPaidAmount = 0;
                    _lastPaymentFor = paymentFor;

                    context.read<MarkPaymentBloc>().add(
                      MarkBulkPaymentRequested(
                        token: widget.token,
                        requestModel: BulkMarkPaymentRequestModel(
                          payments: requests,
                        ),
                      ),
                    );

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Pay All'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMarkPaymentDialog(BuildContext context, dynamic payment) {
    final student = payment.student;
    final studentClass = payment.studentClass;
    final category = payment.classCategory;

    final months = const [
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
      text: payment.finalFee.toStringAsFixed(0),
    );

    bool useSuggestedFee = true;
    int selectedY = DateTime.now().year;
    String selectedM = _monthName(DateTime.now().month);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Confirm Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student: ${student.initialName}'),
                    Text('Class: ${studentClass.className}'),
                    Text('Category: ${category.categoryName}'),
                    const SizedBox(height: 8),
                    Text(
                      'Suggested Amount: LKR ${payment.finalFee.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (payment.discountPercentage != null &&
                        payment.discountPercentage!.isNotEmpty)
                      Text(
                        'Discount: ${payment.discountPercentage}% (${payment.discountType ?? '-'})',
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedY,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder(),
                            ),
                            items: years
                                .map(
                                  (y) => DropdownMenuItem<int>(
                                    value: y,
                                    child: Text('$y'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedY = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedM,
                            decoration: const InputDecoration(
                              labelText: 'Month',
                              border: OutlineInputBorder(),
                            ),
                            items: months
                                .map(
                                  (m) => DropdownMenuItem<String>(
                                    value: m,
                                    child: Text(m),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedM = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use suggested fee'),
                      subtitle: Text(
                        'LKR ${payment.finalFee.toStringAsFixed(0)}',
                      ),
                      value: useSuggestedFee,
                      onChanged: (val) {
                        setState(() {
                          useSuggestedFee = val ?? true;
                          if (useSuggestedFee) {
                            amountController.text = payment.finalFee
                                .toStringAsFixed(0);
                          }
                        });
                      },
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      enabled: !useSuggestedFee,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: 'LKR ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    amountController.dispose();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enteredAmount =
                        int.tryParse(amountController.text.trim()) ??
                        payment.finalFee.toInt();

                    final finalAmount = useSuggestedFee
                        ? payment.finalFee.toInt()
                        : enteredAmount;

                    final paymentFor = '$selectedY $selectedM';

                    final paymentRequest = MarkPaymentRequestModel(
                      paymentDate: DateTime.now().toIso8601String(),
                      status: true,
                      amount: finalAmount,
                      studentId: student.id,
                      studentStudentClassId:
                          payment.studentStudentStudentClassesId,
                      paymentFor: paymentFor,
                      guardianMobile: student.guardianMobile,
                    );

                    _lastRequestedPayment = payment;
                    _lastPaidAmount = finalAmount;
                    _lastPaymentFor = paymentFor;
                    _lastRequestedBulkPayments = [];

                    context.read<MarkPaymentBloc>().add(
                      MarkPaymentRequested(
                        token: widget.token,
                        requestModel: paymentRequest,
                      ),
                    );

                    amountController.dispose();
                    Navigator.pop(dialogContext);
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
