import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

class MyScanner extends ConsumerStatefulWidget {
  const MyScanner({super.key, required this.goToResult});

  final void Function() goToResult;
  @override
  ConsumerState<MyScanner> createState() {
    return _MyScanner();
  }
}

class _MyScanner extends ConsumerState<MyScanner> {
  String? detectedBarcode;
  late MobileScannerController _scannerController;
  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: true,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose(); // Ensure resources are properly released
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 300), () {
      _scannerController.start(); // Restart scanner when returning
    });
  }

  void onDetectCode(String? barcode) {
    if (barcode != null) {
      String barcodeString = barcode;
      if (barcode.length == 13) {
        barcodeString = barcode.substring(0, 12);
      }

      ref.read(scanProvider.notifier).saveScannedId(barcodeString);
      widget.goToResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (detectedBarcode != null) {
    //     String barcodeString = detectedBarcode!;
    //     if(detectedBarcode!.length == 13){
    //       barcodeString = detectedBarcode!.substring(0, 12);
    //     }

    //     ref.read(scanProvider.notifier).saveScannedId(barcodeString);
    //     widget.goToResult();
    //   }
    // });

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(color: Colors.red),
          child: MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              // print('capture');
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                print('SCANNED ${barcode.rawValue}');
                print('Barcode found! ${barcode.rawValue}');
                // setState(() {
                //   detectedBarcode = barcode.rawValue;
                // });

                onDetectCode(barcode.rawValue);
                return;
              }
            },
          ),
        ),
        _buildScanOverlay()
      ],
    );
  }
}

class QRBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 38, 167, 72)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const borderLength = 40.0;

    // Draw the four corner borders
    Path path = Path();
    path.moveTo(0, borderLength);
    path.lineTo(0, 0);
    path.lineTo(borderLength, 0);

    path.moveTo(size.width, borderLength);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - borderLength, 0);

    path.moveTo(0, size.height - borderLength);
    path.lineTo(0, size.height);
    path.lineTo(borderLength, size.height);

    path.moveTo(size.width, size.height - borderLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - borderLength, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Widget _buildScanOverlay() {
  return Center(
    child: CustomPaint(
      size: Size(double.infinity, 300),
      painter: QRBorderPainter(),
    ),
  );
}
