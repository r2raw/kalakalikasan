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
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/screens/collection_officer/home_officer.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class ReceiptQrResultScreen extends ConsumerStatefulWidget {
  const ReceiptQrResultScreen({super.key});
  @override
  ConsumerState<ReceiptQrResultScreen> createState() {
    return _ReceiptQrResultScreen();
  }
}

class _ReceiptQrResultScreen extends ConsumerState<ReceiptQrResultScreen> {
  List materials = [];
  bool _isSending = false;
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
      setState(() {
        _isSending = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com', 'officer-receipt');
      final userid = ref.read(currentUserProvider)[CurrentUser.id];
      final transactionId =
          ref.read(receiptProvider)[ReceiptItem.transactionId];
      final points = ref.read(receiptProvider)[ReceiptItem.points];
      final claimer = ref.read(userQrProvider)[UserQr.userId];
      final response = await http.patch(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          'transaction_officer': userid,
          'transactionId': transactionId,
          'points': points,
          'claimed_by': claimer,
        }),
      );

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);
        setState(() {
          _isSending = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              decoded['error'],
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }
      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => CollectionOfficerScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      throw Exception('Claiming failed: $e');
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
    final qrInfo = ref.read(userQrProvider);

    final fullname = '${qrInfo[UserQr.firstName]} ${qrInfo[UserQr.lastName]}';
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          // decoration:
          //     const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
          child: Column(
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
                            Image.asset('assets/icons/basura_icon.png',
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
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 33, 77, 44)),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  textTruncate(toTitleCase(fullname), 24),
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
                                            color: Color.fromARGB(
                                                255, 33, 77, 44)),
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
                                            color: Color.fromARGB(
                                                255, 33, 77, 44)),
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
                                            color: Color.fromARGB(
                                                255, 33, 77, 44)),
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
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
              SizedBox(
                height: 20,
              ),
              if (status != 'completed' && _isSending) LoadingLg(20),
              if (status != 'completed' && !_isSending)
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
                ),
            ],
          ),
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
