import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/enter_transaction.dart';
import 'package:kalakalikasan/screens/collection_officer/home_barcode_scan.dart';
import 'package:kalakalikasan/screens/collection_officer/scan_user_qr.dart';
import 'package:kalakalikasan/screens/eco_partners/enter_username.dart';
import 'package:kalakalikasan/widgets/actors/schedule_list.dart';
import 'package:kalakalikasan/widgets/actors/weekly_schedule.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;

class OfficerClaimReceiptScreen extends ConsumerStatefulWidget {
  const OfficerClaimReceiptScreen({super.key});

  @override
  ConsumerState<OfficerClaimReceiptScreen> createState() {
    return _OfficerClaimReceiptScreen();
  }
}

class _OfficerClaimReceiptScreen
    extends ConsumerState<OfficerClaimReceiptScreen> {
  String? currentScreen;

  void _onPressTransactionId() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (ctx) => EnterTransactionScreen(),
      ),
    );

    if(result == null){
      return;
    }

    if(result == true){
      setState(() {
        currentScreen = 'qr';
      });
    }
  }


  void goToResult() async {
    final scannedId = ref.read(scanProvider);
    try {
      if (scannedId.length <= 13) {
        final url = Uri.https(
            'kalakalikasan-server.onrender.com', 'get-receipt/${scannedId}');
        final response = await http.get(url);
        final decoded = json.decode(response.body);

        final receipt = decoded['receipt'];
        if (response.statusCode >= 400) {
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              content: Text(
                decoded['error'],
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )));
        }

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).clearSnackBars();
          final receiptData = {
            ReceiptItem.transactionId: receipt['transaction_id'],
            ReceiptItem.transactionDate: receipt['transaction_date'],
            ReceiptItem.materials: receipt['materials'],
            ReceiptItem.points: receipt['total_points'],
            ReceiptItem.status: receipt['claiming_status'],
            ReceiptItem.type: receipt['claiming_type'],
          };

          if (receipt['claiming_status'] == 'completed') {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Receipt has been claimed already!')));
            return;
          }
          ref.read(receiptProvider.notifier).saveReceipt(receiptData);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (ctx) => HomeBarcodeScanScreen()));

          setState(() {
            currentScreen = 'qr';
          });
        }
      }
    } catch (e, stackTrace) {
      print('error $e');
      print('stackTrace: $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    Widget content = SingleChildScrollView(
      child: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Scan Barcode',
                        style: Theme.of(context).textTheme.headlineLarge),
                    Text(
                      'Place the barcode inside the area',
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
                  FontAwesome.barcode_solid,
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            MyScanner(
              goToResult: goToResult,
            ),
            SizedBox(
              height: 16,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 32, 77, 44)),
              onPressed: _onPressTransactionId,
              label: Text('Enter transaction ID'),
              icon: Icon(Icons.keyboard),
            ),
          ],
        ),
      ),
    );

    if (currentScreen == 'qr') {
      content = HomeBarcodeScanScreen();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
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
        title: const Text('Claim Receipt'),
      ),
      body: content,
    );
  }
}
