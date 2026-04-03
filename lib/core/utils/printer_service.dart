import 'dart:async';
import 'dart:developer';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  final FlutterThermalPrinter _printer = FlutterThermalPrinter.instance;
  Printer? _connectedPrinter;

  Printer? get selectedPrinter => _connectedPrinter;
  bool get isConnected => _connectedPrinter != null;

  Future<void> connectPrinter(Printer printer) async {
    try {
      if (_connectedPrinter != null) {
        await _printer.disconnect(_connectedPrinter!);
      }

      await _printer.connect(
        printer,
        connectionStabilizationDelay: const Duration(seconds: 2),
      );

      _connectedPrinter = printer;
      log("Connected to: ${printer.name}");
    } catch (e) {
      log("Connect error: $e");
      rethrow;
    }
  }

  Future<void> disconnectPrinter() async {
    try {
      if (_connectedPrinter != null) {
        await _printer.disconnect(_connectedPrinter!);
        log("Disconnected from: ${_connectedPrinter!.name}");
        _connectedPrinter = null;
      }
    } catch (e) {
      log("Disconnect error: $e");
      rethrow;
    }
  }

  Future<List<Printer>> getAvailablePrinters() async {
    final completer = Completer<List<Printer>>();
    StreamSubscription<List<Printer>>? sub;

    sub = _printer.devicesStream.listen((devices) {
      final printers = devices
          .where((d) => d.name != null && d.name!.isNotEmpty)
          .toList();

      if (!completer.isCompleted) {
        completer.complete(printers);
      }
      sub?.cancel();
    });

    await _printer.getPrinters(
      connectionTypes: [ConnectionType.BLE],
      refreshDuration: const Duration(seconds: 5),
    );

    return completer.future;
  }

  Future<void> selectPrinter(Printer printer) async {
    await connectPrinter(printer);
  }

  Future<void> printData(List<int> data) async {
    if (_connectedPrinter == null) {
      throw Exception("Printer not connected");
    }

    const chunkSize = 100;

    for (int i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize > data.length) ? data.length : i + chunkSize;

      await _printer.printData(
        _connectedPrinter!,
        data.sublist(i, end),
      );

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}