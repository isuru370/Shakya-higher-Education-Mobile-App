import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/temp_qr/temp_qr_bloc.dart';

class TempQrPage extends StatefulWidget {
  final String token;
  const TempQrPage({super.key, required this.token});

  @override
  State<TempQrPage> createState() => _TempQrPageState();
}

class _TempQrPageState extends State<TempQrPage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, GlobalKey> _qrKeys = {};

  @override
  void initState() {
    super.initState();
    context.read<TempQrBloc>().add(FetchTempQrEvent(token: widget.token));
  }

  void _onSearchChanged() {
    context.read<TempQrBloc>().add(
      FetchTempQrEvent(token: widget.token, search: _searchController.text),
    );
  }

  // =========================
  // TEXT ONLY WHATSAPP
  // =========================
  void openWhatsApp(String phoneNumber, String message) async {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '94${phoneNumber.substring(1)}';
    }

    final whatsappUrl = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Could not launch WhatsApp'),
        ),
      );
    }
  }

  // =========================
  // SAVE QR IMAGE
  // =========================
  Future<String> saveQrImage(GlobalKey key, String token) async {
    try {
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();

      // Unique filename (avoid override)
      final file = await File('${tempDir.path}/qr_$token.png').create();

      await file.writeAsBytes(pngBytes);

      return file.path;
    } catch (e) {
      return '';
    }
  }

  // =========================
  // SHARE IMAGE (New API)
  // =========================
  void shareQrImage(GlobalKey key, String token, String message) async {
    final path = await saveQrImage(key, token);

    if (path.isNotEmpty) {
      final result = await SharePlus.instance.share(
        ShareParams(text: message, files: [XFile(path)]),
      );

      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('QR shared successfully ✅'),
          ),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Share cancelled ❌'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to share QR'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to generate QR image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temporary QR Codes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name, custom ID, mobile...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _onSearchChanged(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<TempQrBloc, TempQrState>(
                builder: (context, state) {
                  if (state is TempQrLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TempQrLoaded) {
                    if (state.qrList.isEmpty) {
                      return const Center(
                        child: Text('No temporary QR codes found.'),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.qrList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final qr = state.qrList[index];
                        final qrKey = _qrKeys[qr.temporaryQrCode] ??=
                            GlobalKey();

                        final formattedDate = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(qr.updateAt);

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          qr.initialName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const SizedBox(height: 12),

                                        // Student Details below QR
                                        Text(
                                          'Custom ID: ${qr.temporaryQrCode}',
                                        ),
                                        Text('Expires At: $formattedDate'),
                                        Text('Days Left: ${qr.daysLeft}'),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                    // Header: Name
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Center(
                                          child: RepaintBoundary(
                                            key: qrKey,
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(8),
                                              child: QrImageView(
                                                data: qr.temporaryQrCode,
                                                version: QrVersions.auto,
                                                size: 80,
                                                backgroundColor: Colors.white,
                                                dataModuleStyle:
                                                    const QrDataModuleStyle(
                                                      color: Colors.black,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            final message =
                                                'ඔබේ temporary QR code';
                                            shareQrImage(
                                              qrKey,
                                              qr.temporaryQrCode,
                                              message,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.image,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Share',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 2,
                                          ),
                                        ),

                                        // QR Code BELOW Status
                                      ],
                                    ),

                                    // Status

                                    // Share button
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is TempQrError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
