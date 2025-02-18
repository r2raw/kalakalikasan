import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/points_provider.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class BarcodeResult extends ConsumerStatefulWidget {
  const BarcodeResult({super.key});
  @override
  ConsumerState<BarcodeResult> createState() {
    return _BarcodeResult();
  }
}

class _BarcodeResult extends ConsumerState<BarcodeResult> {
  List materials = [];
  @override
  void initState() {
    super.initState();

    final receiptData = ref.read(receiptProvider)[ReceiptItem.materials];

    setState(() {
      materials = receiptData;
    });
  }

  void _onClaim() async {
    try {
      final url = Uri.http(ref.read(urlProvider), 'receipt');
      final userid = ref.read(currentUserProvider)[CurrentUser.id];
      final transactionId =
          ref.read(receiptProvider)[ReceiptItem.transactionId];
      final points = ref.read(receiptProvider)[ReceiptItem.points];
      final response = await http.patch(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          'userId': userid,
          'transactionId': transactionId,
          'points': points
        }),
      );

      if (response.statusCode == 200) {
        final int points = ref.read(receiptProvider)[ReceiptItem.points];

        final int currPoints = ref.read(pointsProvider);

        final int updatedPoints = currPoints + points;
        ref.read(pointsProvider.notifier).updatePoints(updatedPoints);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => EcoActors()),
          (route) => false,
        );
      }
    } catch (e) {
      throw Exception('Claiming failed: $e');
    }
  }

  Future<void> _captureAndSave(BuildContext context) async {
    try {
      // 1) Capture logic
      RenderRepaintBoundary boundary = _widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2) Get the Downloads folder path
      final directory = await getExternalStorageDirectory();
      final downloadDirectory = Directory('${directory?.path}/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }

      // 3) Save the image in the Downloads folder
      final file = File(
          '${downloadDirectory.path}/IMG-${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      print('Image saved to ${file.path}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved to ${file.path}'),
        ),
      );
    } catch (e) {
      throw Exception('Failed to capture and save image: $e');
    }
  }

  final GlobalKey _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final transactionId = ref.read(receiptProvider)[ReceiptItem.transactionId];
    final transactionDate =
        myDateTime(ref.read(receiptProvider)[ReceiptItem.transactionDate]);
    final points = ref.read(receiptProvider)[ReceiptItem.points];
    final status = ref.read(receiptProvider)[ReceiptItem.status];
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Result'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RepaintBoundary(
                key: _widgetKey,
                child: ClipPath(
                  clipper: TicketClipper(),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/kalakalikasan_icon.png',
                              width: 96, height: 96),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction ID',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 33, 77, 44)),
                              ),
                              Text(
                                transactionId,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 33, 77, 44),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 33, 77, 44)),
                              ),
                              Text(
                                transactionDate,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 33, 77, 44),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Material',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44),
                                          fontWeight: FontWeight.bold)),
                                  for (final material in materials)
                                    Text(
                                      material['material_name'],
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Grams',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44),
                                          fontWeight: FontWeight.bold)),
                                  for (final material in materials)
                                    Text(
                                      material['total_grams'].toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Points',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44),
                                          fontWeight: FontWeight.bold)),
                                  for (final material in materials)
                                    Text(
                                      material['points_collected'].toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/token-img.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 4),
                              Text(
                                points.toString(),
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // TextButton.icon(
                          //   onPressed: () async {
                          //     await _captureAndSave(context);
                          //   },
                          //   label: Text('Download receipt'),
                          //   icon: Icon(Icons.download),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            if (status != 'claimed')
              
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 32, 77, 44),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onClaim,
                  child: const Text(
                    'Claim',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              
          ],
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 16.0;

    // Rounded rectangle shape
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    // Perforation settings
    double holeRadius = 10; // Adjust for better look
    double gap = 6; // Space between circles
    double sidePadding = 16; // Left and Right padding

    Path holes = Path();
    for (double x = sidePadding;
        x < size.width - sidePadding;
        x += holeRadius * 2 + gap) {
      holes.addOval(Rect.fromCircle(
        center: Offset(x + holeRadius, size.height),
        radius: holeRadius,
      ));
    }

    return Path.combine(PathOperation.difference, path, holes);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
