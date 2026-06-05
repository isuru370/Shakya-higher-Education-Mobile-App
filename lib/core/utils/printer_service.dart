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

  bool _isBluetoothOffError(Object error) {
    return error.toString().toLowerCase().contains('bluetooth is turned off');
  }

  Future<void> connectPrinter(Printer printer) async {
    try {
      if (_connectedPrinter != null) {
        try {
          await _printer.disconnect(_connectedPrinter!);
          log('Disconnected old printer: ${_connectedPrinter!.name}');
        } catch (e) {
          log('Old disconnect error: $e');
        }
      }

      await _printer.connect(
        printer,
        connectionStabilizationDelay: const Duration(seconds: 2),
      );

      _connectedPrinter = printer;
      log('Connected to: ${printer.name}');
    } catch (e, st) {
      log('Connect error: $e', stackTrace: st);

      if (_isBluetoothOffError(e)) {
        throw Exception(
          'Bluetooth is turned off. Please enable Bluetooth first.',
        );
      }

      rethrow;
    }
  }

  Future<void> disconnectPrinter() async {
    try {
      if (_connectedPrinter != null) {
        await _printer.disconnect(_connectedPrinter!);
        log('Disconnected from: ${_connectedPrinter!.name}');
        _connectedPrinter = null;
      }
    } catch (e, st) {
      log('Disconnect error: $e', stackTrace: st);
      rethrow;
    }
  }

  Future<List<Printer>> getAvailablePrinters() async {
    final found = <Printer>[];
    final completer = Completer<List<Printer>>();
    StreamSubscription<List<Printer>>? sub;

    sub = _printer.devicesStream.listen(
      (devices) {
        for (final d in devices) {
          log(
            'Found device => name: ${d.name}, address: ${d.address}, type: ${d.connectionType}',
          );

          final alreadyExists = found.any((p) => p.address == d.address);
          final matches = d.name != null && d.name!.contains('PT-210');

          if (matches && !alreadyExists) {
            found.add(d);
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log('Device stream error: $error', stackTrace: stackTrace);

        if (!completer.isCompleted) {
          if (_isBluetoothOffError(error)) {
            completer.complete(found);
          } else {
            completer.completeError(error, stackTrace);
          }
        }
      },
      cancelOnError: false,
    );

    try {
      await _printer.getPrinters(
        connectionTypes: [ConnectionType.BLE],
        refreshDuration: const Duration(seconds: 5),
      );

      await Future.delayed(const Duration(seconds: 5));

      if (!completer.isCompleted) {
        completer.complete(found);
      }
    } catch (e, st) {
      log('Scan error: $e', stackTrace: st);

      if (!completer.isCompleted) {
        if (_isBluetoothOffError(e)) {
          completer.complete(found);
        } else {
          completer.completeError(e, st);
        }
      }
    } finally {
      await sub.cancel();
    }

    return completer.future;
  }

  Future<void> selectPrinter(Printer printer) async {
    await connectPrinter(printer);
  }

  Future<void> printData(List<int> data) async {
    if (_connectedPrinter == null) {
      throw Exception('Printer not connected');
    }

    const chunkSize = 100;

    log('Print bytes length: ${data.length}');

    for (int i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize > data.length) ? data.length : i + chunkSize;
      final chunk = data.sublist(i, end);

      log('Sending chunk: $i - $end');

      await _printer.printData(_connectedPrinter!, chunk);
      await Future.delayed(const Duration(milliseconds: 120));
    }

    log('Print completed');
  }
}
