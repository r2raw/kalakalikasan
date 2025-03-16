import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/model/receipt.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/enter_transaction.dart';
import 'package:kalakalikasan/screens/collection_officer/receipt_qr_result.dart';
import 'package:kalakalikasan/screens/eco_partners/enter_username.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;

class QrFirstReceipt extends ConsumerStatefulWidget {
  const QrFirstReceipt({super.key});

  @override
  ConsumerState<QrFirstReceipt> createState() {
    // TODO: implement createState
    return _QrFirstReceipt();
  }
}

class _QrFirstReceipt extends ConsumerState<QrFirstReceipt> {
  String? _error;
  void _onPressTransactionId() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (ctx) => EnterTransactionScreen(
          origin: 'qr-first',
        ),
      ),
    );
  }

  void goToResult() async {
    final scannedId = ref.read(scanProvider);
    try {
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'get-receipt/$scannedId');

      final response = await http.get(url);

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);
        setState(() {
          _error = decoded['error'];
        });

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
      }
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final receipt = decoded['receipt'];

        if (receipt['claiming_status'] == 'completed') {
          setState(() {
            _error = 'Receipt has been claimed already!';
          });

          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
          return;
        }
        final receiptData = {
          ReceiptItem.transactionId: receipt['transaction_id'],
          ReceiptItem.transactionDate: receipt['transaction_date'],
          ReceiptItem.materials: receipt['materials'],
          ReceiptItem.points: receipt['total_points'],
          ReceiptItem.status: receipt['claiming_status'],
          ReceiptItem.type: receipt['claiming_type'],
        };
        ref.read(receiptProvider.notifier).saveReceipt(receiptData);
        ScaffoldMessenger.of(context).clearSnackBars();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ReceiptQrResultScreen(),
          ),
        );
        return;
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Scan Barcode'),
          centerTitle: true,
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
                SizedBox(
                  height: 12,
                ),
                if (_error != null) ErrorSingle(errorMessage: _error)
              ],
            ),
          ),
        ));
  }
}
