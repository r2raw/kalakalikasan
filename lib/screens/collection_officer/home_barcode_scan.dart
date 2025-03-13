import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/direct_cash.dart';
import 'package:kalakalikasan/screens/collection_officer/receipt_qr_result.dart';
import 'package:kalakalikasan/screens/eco_partners/enter_username.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/second_scanner.dart';

class HomeBarcodeScanScreen extends ConsumerStatefulWidget {
  const HomeBarcodeScanScreen({super.key});

  @override
  ConsumerState<HomeBarcodeScanScreen> createState() {
    return _HomeBarcodeScanScreen();
  }
}

class _HomeBarcodeScanScreen extends ConsumerState<HomeBarcodeScanScreen> {
  void goToResult() async {
    final scannedId = ref.read(scanProvider);
    try {
      final url = Uri.https('kalakalikasan-server.onrender.com', 'qr-scan-user/${scannedId}');

      final response = await http.get(url);

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: Text(
              decoded['error'],
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final userData = {
          UserQr.firstName: decoded['firstname'],
          UserQr.lastName: decoded['lastname'],
          UserQr.points: decoded['points'],
          UserQr.userId: decoded['userId'],
        };

        ref.read(userQrProvider.notifier).loadUserQr(userData);
        ScaffoldMessenger.of(context).clearSnackBars();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ReceiptQrResultScreen(),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('error $e');
      print('stackTrace: $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Oops! Something went wrong.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.surfaceContainer,
            ),
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
          ],
        ),
      ),
    );
  }
}
