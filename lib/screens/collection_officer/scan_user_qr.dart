import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/collect_materials.dart';
import 'package:kalakalikasan/screens/collection_officer/collected_materials_summary.dart';
import 'package:kalakalikasan/screens/collection_officer/direct_cash.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/eco_partners/enter_username.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;

class ScanUserQrScreen extends ConsumerStatefulWidget{
  const ScanUserQrScreen({super.key});

  @override
  ConsumerState<ScanUserQrScreen> createState() {
    return _ScanUserQrScreen();
  }
}

class _ScanUserQrScreen extends ConsumerState<ScanUserQrScreen> {
  
  void goToResult() async {
    final scannedId = ref.read(scanProvider);
    try {

        final url = Uri.https('kalakalikasan-server.onrender.com', 'qr-scan-user/$scannedId');

        final response = await http.get(url);
          final decoded = json.decode(response.body);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(decoded['error'])));
        }
        if (response.statusCode == 200) {

          final userData = {
            UserQr.userId: decoded['userId'],
            UserQr.firstName: decoded['firstname'],
            UserQr.lastName: decoded['lastname'],
            UserQr.points: decoded['points']
          };
          ref.read(userQrProvider.notifier).loadUserQr(userData);

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) =>  CollectedMaterialsSummaryScreen()));
        }
      
    } catch (e, stackTrace) {
      print('error $e');
      print('stackTrace: $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong.')));
    }
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Scan Qr'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
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
          height: h,
          width: w,
          padding: EdgeInsets.all(20),
          // decoration: BoxDecoration(
          //   color: Theme.of(context).colorScheme.surfaceContainer,
          // ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Scan QR',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text(
                        'Place the QR inside the area',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Scanning will start automaticallly',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.qr_code,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              MyScanner(goToResult: goToResult),
              SizedBox(
                height: 16,
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => EnterUsernameScreen(),
                    ),
                  );
                },
                label: Text('Enter username'),
                icon: Icon(Icons.keyboard),
              ),
              SizedBox(
                height: 8,
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => DirectCashScreen(),
                    ),
                  );
                },
                label: Text('Direct cash'),
                icon: Icon(IonIcons.cash),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
