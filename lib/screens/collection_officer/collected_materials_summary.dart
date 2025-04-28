import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/rates_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/util/otp.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class CollectedMaterialsSummaryScreen extends ConsumerStatefulWidget {
  const CollectedMaterialsSummaryScreen({super.key});
  @override
  ConsumerState<CollectedMaterialsSummaryScreen> createState() {
    return _CollectedMaterialsSummaryScreen();
  }
}

class _CollectedMaterialsSummaryScreen
    extends ConsumerState<CollectedMaterialsSummaryScreen> {
  final GlobalKey _widgetKey = GlobalKey();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
  }


  void _submitMaterials() async {
    try {
      final url = Uri.https('kalakalikasan-server.onrender.com', 'smart-bin-officer');

      setState(() {
        _isSending = true;
      });
      final canWeight = ref.read(manualCollectProvider)[ManualCollect.can];
      final petWeight =
          ref.read(manualCollectProvider)[ManualCollect.petBottle];
      final userId = ref.read(userQrProvider)[UserQr.userId];
      final rates = ref.read(ratesProvider);

      final canPoints = ((canWeight) / (rates[Rates.canPoints])).toInt();
      final petPoints = ((petWeight) / (rates[Rates.petPoints])).toInt();
      final totalPoints = canPoints + petPoints;
      final List materials = [
        {
          'material_name': 'pet bottle',
          'points_collected': petPoints,
          'total_grams': petWeight,
        },
        {
          'material_name': 'can',
          'points_collected': canPoints,
          'total_grams': canWeight,
        }
      ];

      final Map binData = {
        'transaction_id': generateTransactionID(),
        'materials': materials,
        'total_points': totalPoints,
        'collecting_officer': ref.read(currentUserProvider)[CurrentUser.id],
        'claimed_by': userId,
      };
      final response = await http.post(url,
          headers: {'Content-type': 'application/json'},
          body: json.encode(binData));

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);
        final error = decoded['error'];
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)));
      }
      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });
        if (!context.mounted) {
          return;
        }
        if (ref.read(userQrProvider).isEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CollectedMaterialsSummaryScreen()));
          return;
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => CollectionOfficerScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWeight = ref.read(manualCollectProvider)[ManualCollect.can];
    final petWeight = ref.read(manualCollectProvider)[ManualCollect.petBottle];
    final rates = ref.read(ratesProvider);

    final canPoints = ((canWeight) / (rates[Rates.canPoints])).toInt();
    final petPoints = ((petWeight) / (rates[Rates.petPoints])).toInt();
    final totalPoints = canPoints + petPoints;

    final userInfo = ref.read(userQrProvider);
    final fullName = '${userInfo[UserQr.firstName]} ${userInfo[UserQr.lastName]}';
    Widget content = Center(
      child: Text('User data not found'),
    );


    if (fullName.isNotEmpty) {
      content = Column(
        children: [
          SingleChildScrollView(
            child: Expanded(
              child: Center(
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
                            Image.asset('assets/icons/basura_bot_text.png',
                                width: 96, height: 96),
                            SizedBox(
                              height: 12,
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
                                  dateNow(),
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
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 33, 77, 44)),
                                ),
                                Text(
                                  toTitleCase(fullName),
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
                                    Text(
                                      'can',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                    Text(
                                      'pet bottle',
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
                                    Text(
                                      canWeight.toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                    Text(
                                      petWeight.toString(),
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
                                    Text(
                                      canPoints.toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 33, 77, 44)),
                                    ),
                                    Text(
                                      petPoints.toString(),
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
                                  totalPoints.toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (_isSending) LoadingLg(20),
          if (!_isSending)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 32, 77, 44),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _submitMaterials,
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            )
        ],
      );
    }

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
      body: Container(
        padding: EdgeInsets.all(20),
        // decoration:
        //     const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: SingleChildScrollView(child: content),
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
