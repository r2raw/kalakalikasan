import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/barcode_result.dart';
import 'package:kalakalikasan/screens/eco_actor/transaction_receipt.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;

class QrActor extends ConsumerStatefulWidget {
  const QrActor({super.key});
  @override
  ConsumerState<QrActor> createState() {
    return _QrActor();
  }
}

class _QrActor extends ConsumerState<QrActor> {
  String? _error;
  void _goToResult() async {
    try {
      final transactionId = ref.read(scanProvider);
      
      final url = Uri.https('kalakalikasan-server.onrender.com', '/get-receipt/$transactionId');
      final response = await http.get(url);
      final decoded = json.decode(response.body);
      final receipt = decoded['receipt'];

      if (response.statusCode >= 400) {
        setState(() {
          _error = decoded['error'];
        });
      }
      if (response.statusCode == 200) {
        final receiptData = {
          ReceiptItem.transactionId: receipt['transaction_id'],
          ReceiptItem.transactionDate: receipt['transaction_date'],
          ReceiptItem.materials: receipt['materials'],
          ReceiptItem.points: receipt['total_points'],
          ReceiptItem.status: receipt['claiming_status'],
          ReceiptItem.type: receipt['claiming_type'],
        };

        ref.read(receiptProvider.notifier).saveReceipt(receiptData);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => BarcodeResult(),
          ),
        );
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      // decoration: const BoxDecoration(
      //   color: Color.fromARGB(255, 233, 233, 233),
      // ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 140),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place the barcode inside the area',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              Text(
                'Scanning will start automaticallly',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              Spacer(),
              MyScanner(goToResult: _goToResult),
              SizedBox(
                height: 16,
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => TransactionReceipt()));
                },
                label: Text('Enter transaction id'),
                icon: Icon(Icons.keyboard),
              )
            ],
          ),
        ),
      ),
    );
  }
}
