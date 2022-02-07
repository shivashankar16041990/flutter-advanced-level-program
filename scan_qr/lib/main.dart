import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey qr_key = GlobalKey(debugLabel: " QR key");

  Barcode? result;

  QRViewController? qrViewController;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
       qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: QRView(key: qr_key, onQRViewCreated: _onQRViewCreated),
            ),
            Expanded(
              flex: 1,
              child: (result != null)
                  ? Text(" code format ${result!.format},\n ${result!.code}  ")
                  : const Text("Scan a code"),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {qrViewController!.toggleFlash();},
                    child: const Text("Flash on / off"),
                  ),
                  SizedBox(width:10),
                  ElevatedButton(
                    onPressed: () {qrViewController!.flipCamera();},
                    child: const Text("flipCamera"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController p1) {
    qrViewController = p1;
    qrViewController!.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
    });
  }
}
