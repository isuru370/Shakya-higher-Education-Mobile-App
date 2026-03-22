import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../route_observer.dart';
import '../bloc/temp_qr/temp_qr_bloc.dart';

class ActivatedStudentQrPage extends StatefulWidget {
  final String token;

  const ActivatedStudentQrPage({super.key, required this.token});

  @override
  State<ActivatedStudentQrPage> createState() => _ActivatedStudentQrPageState();
}

class _ActivatedStudentQrPageState extends State<ActivatedStudentQrPage>
    with RouteAware {
  bool _hasPermission = false;
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() => _isScanned = false);
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    setState(() => _hasPermission = status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Permission'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: const Center(
          child: Text(
            'Camera permission is required to scan QR codes.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return BlocListener<TempQrBloc, TempQrState>(
      listener: (context, state) {
        if (state is ActivatedTempQrLoaded) {
          final response = state.activatedQr;

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Success"),
                  ],
                ),
                content: Text(response.message),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _isScanned = false);
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }

        if (state is TempQrError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: Text('Active QR Code'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) {
                if (_isScanned) return;

                final value = capture.barcodes.first.rawValue;
                if (value == null || value.isEmpty) return;

                _isScanned = true;

                context.read<TempQrBloc>().add(
                  ActivatedTempQrEvent(token: widget.token, customId: value),
                );
              },
            ),
            Center(
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
          ],
        ),
      ),
    );
  }
}
