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
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (detectedBarcode != null) {
        ref.read(scanProvider.notifier).saveScannedId(detectedBarcode!);
        widget.goToResult();
      }
    });
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(color: Colors.red),
          child: MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) {
              // print('capture');
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                print('Barcode found! ${barcode.rawValue}');
                setState(() {
                  detectedBarcode = barcode.rawValue;
                });
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
      ..color = Color.fromARGB(255, 38,167, 72)
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
