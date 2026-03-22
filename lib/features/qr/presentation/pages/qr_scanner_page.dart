import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/enums/scan_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../route_observer.dart';
import '../../../students/presentaion/pages/single_student_view_page.dart';
import '../bloc/read_attendance/read_attendance_bloc.dart';
import '../bloc/read_payment/read_payment_bloc.dart';
import '../bloc/read_student/read_student_bloc.dart';
import '../bloc/read_student_classes/read_student_classes_bloc.dart';
import '../bloc/read_tute/read_tute_bloc.dart';

class QrScannerPage extends StatefulWidget {
  final ScanType scanType;
  final String token;

  const QrScannerPage({super.key, required this.scanType, required this.token});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> with RouteAware {
  bool _hasPermission = false;
  bool _isScanned = false;
  bool _isHandlingResult = false;

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  final TextEditingController _customIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _customIdController.dispose();
    _focusNode.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _customIdController.clear();
    _resetScanner();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    setState(() {
      _hasPermission = status.isGranted;
    });

    if (_hasPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _safeStartScanner();
      });
    }
  }

  Future<void> _safeStartScanner() async {
    try {
      await _scannerController.start();
    } catch (_) {}
  }

  Future<void> _safeStopScanner() async {
    try {
      await _scannerController.stop();
    } catch (_) {}
  }

  void _resetScanner() {
    if (!mounted) return;

    setState(() {
      _isScanned = false;
      _isHandlingResult = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeStartScanner();
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleScanValue(String value) async {
    if (!mounted) return;
    if (_isScanned || _isHandlingResult) return;

    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    setState(() {
      _isScanned = true;
      _isHandlingResult = true;
    });

    _focusNode.unfocus();
    await _safeStopScanner();

    switch (widget.scanType) {
      case ScanType.attendance:
        context.read<ReadAttendanceBloc>().add(
          ReadAttendanceRequested(token: widget.token, customId: trimmedValue),
        );
        break;

      case ScanType.payment:
        context.read<ReadPaymentBloc>().add(
          ReadPaymentRequested(token: widget.token, customId: trimmedValue),
        );
        break;

      case ScanType.student:
        context.read<ReadStudentBloc>().add(
          ReadStudentRequested(token: widget.token, customId: trimmedValue),
        );
        break;

      case ScanType.tute:
        context.read<ReadTuteBloc>().add(
          ReadTuteRequested(token: widget.token, customId: trimmedValue),
        );
        break;

      case ScanType.classes:
        context.read<ReadStudentClassesBloc>().add(
          ReadStudentClassesRequested(
            token: widget.token,
            qrCode: trimmedValue,
          ),
        );
        break;
    }
  }

  void _handleManualSubmit() {
    final customId = _customIdController.text.toUpperCase().trim();
    _handleScanValue(customId);
  }

  String _getTitle() {
    switch (widget.scanType) {
      case ScanType.attendance:
        return 'Scan Attendance QR';
      case ScanType.payment:
        return 'Scan Payment QR';
      case ScanType.tute:
        return 'Scan Tute QR';
      case ScanType.classes:
        return 'Add Student Classes';
      case ScanType.student:
        return 'Scan Student';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Permission'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt_outlined, size: 70),
                const SizedBox(height: 16),
                const Text(
                  'Camera permission is required to scan QR codes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _requestPermission,
                  child: const Text('Grant Permission'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ReadAttendanceBloc, ReadAttendanceState>(
          listenWhen: (previous, current) =>
              current is ReadAttendanceLoaded || current is ReadAttendanceError,
          listener: (context, state) async {
            if (state is ReadAttendanceLoaded) {
              if (state.attendanceList.isEmpty) {
                _showSnackBar('Class not available for this student.');
                _resetScanner();
              } else {
                await _safeStopScanner();
                if (!mounted) return;
                Navigator.pushNamed(
                  context,
                  '/attendance-details',
                  arguments: {'token': widget.token, 'attendanceState': state},
                );
              }
            }

            if (state is ReadAttendanceError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadPaymentBloc, ReadPaymentState>(
          listenWhen: (previous, current) =>
              current is ReadPaymentLoaded || current is ReadPaymentError,
          listener: (context, state) async {
            if (state is ReadPaymentLoaded) {
              if (state.response.data.isEmpty) {
                _showSnackBar('No payment records found.');
                _resetScanner();
              } else {
                await _safeStopScanner();
                if (!mounted) return;
                Navigator.pushNamed(
                  context,
                  '/payment-details',
                  arguments: {'token': widget.token, 'paymentState': state},
                );
              }
            }

            if (state is ReadPaymentError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadStudentBloc, ReadStudentState>(
          listenWhen: (previous, current) =>
              current is ReadStudentLoaded || current is ReadStudentError,
          listener: (context, state) async {
            if (state is ReadStudentLoaded) {
              final student = state.response.data;
              if (student != null) {
                await _safeStopScanner();
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SingleStudentViewPage(
                      token: widget.token,
                      student: student,
                    ),
                  ),
                );
              } else {
                _showSnackBar(state.response.message ?? 'Student not found');
                _resetScanner();
              }
            }

            if (state is ReadStudentError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadTuteBloc, ReadTuteState>(
          listenWhen: (previous, current) =>
              current is ReadTuteSuccess || current is ReadTuteFailure,
          listener: (context, state) async {
            if (state is ReadTuteSuccess) {
              final tuteData = state.response.data;
              if (tuteData.isNotEmpty) {
                await _safeStopScanner();
                if (!mounted) return;
                Navigator.pushNamed(
                  context,
                  '/read_tute',
                  arguments: {
                    'token': widget.token,
                    'read_tute_success': state.response,
                  },
                );
              } else {
                _showSnackBar('Tute data not found');
                _resetScanner();
              }
            }

            if (state is ReadTuteFailure) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadStudentClassesBloc, ReadStudentClassesState>(
          listenWhen: (previous, current) =>
              current is ReadStudentClassesSuccess ||
              current is ReadStudentClassesError,
          listener: (context, state) async {
            if (state is ReadStudentClassesSuccess) {
              _showSnackBar(state.response.message);

              await _safeStopScanner();
              if (!mounted) return;

              await Navigator.pushNamed(
                context,
                '/add-student-class',
                arguments: {
                  'token': widget.token,
                  'read_student_classes_state': state.response,
                },
              );

              if (!mounted) return;
              _resetScanner();
            }

            if (state is ReadStudentClassesError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: Text(_getTitle()),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (_isScanned || _isHandlingResult) return;
                if (capture.barcodes.isEmpty) return;

                final value = capture.barcodes.first.rawValue;
                if (value == null || value.trim().isEmpty) return;

                _handleScanValue(value);
              },
            ),
            Center(
              child: IgnorePointer(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.6),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customIdController,
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Enter custom ID',
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _handleManualSubmit(),
                            enabled: !_isScanned && !_isHandlingResult,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: (_isScanned || _isHandlingResult)
                              ? null
                              : _handleManualSubmit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isScanned || _isHandlingResult)
              Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
