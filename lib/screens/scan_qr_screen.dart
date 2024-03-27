import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sport_controller_app/providers/socket_provider.dart';
import 'package:sport_controller_app/router/routes.dart';
import 'package:sport_controller_app/utils/utils.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRWidgetState();
}

class _ScanQRWidgetState extends State<ScanQRScreen> {
  late SocketProvider socketProvider;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final qrScanResult = ValueNotifier('');
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    socketProvider = context.read<SocketProvider>();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    qrScanResult.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan to connect',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        formatsAllowed: const [BarcodeFormat.qrcode],
                        overlay: QrScannerOverlayShape(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: qrScanResult,
                        builder: (context, value, _) {
                          return Text(
                            'Detected result: ${value.isEmpty ? 'None' : value}',
                            textAlign: TextAlign.start,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            ValueListenableBuilder(
                valueListenable: qrScanResult,
                builder: (context, value, _) {
                  return ElevatedButton.icon(
                    onPressed: value.isEmpty
                        ? null
                        : () {
                            _onClickConnect();
                            context.goNamed(Routes.matchDetails.name);
                          },
                    icon: const Icon(Icons.router_outlined),
                    label: const Text(
                      'Connect',
                    ),
                  );
                }),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final code = scanData.code;
      if (null != code) {
        qrScanResult.value = code;
      }
    });
  }

  Future<void> _onClickConnect() async {
    final address = qrScanResult.value;
    dartz.Tuple2<String, int> parsedAddress;
    try {
      parsedAddress = Utils.parseIPAddress(address);
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
    final ipAddress = parsedAddress.value1;
    final port = parsedAddress.value2;
    await socketProvider.connectToSocket(ipAddress, port);
  }
}
