import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/barcode_result.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class TransactionReceipt extends ConsumerStatefulWidget {
  const TransactionReceipt({super.key});

  @override
  ConsumerState<TransactionReceipt> createState() {
    return _TransactionReceipt();
  }
}

class _TransactionReceipt extends ConsumerState<TransactionReceipt> {
  String? tansactionId;
  bool _isSending = false;
  String? _error;
  final _formKey = GlobalKey<FormState>();
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      
      final url = Uri.https('kalakalikasan-server.onrender.com', '/get-receipt/$tansactionId');
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);
        final error = decoded['error'];
        setState(() {
          _isSending = false;
          _error = error;
        });
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
      }
      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });
        final decoded = json.decode(response.body);
        final receipt = decoded['receipt'];

        final receiptData = {
          ReceiptItem.transactionId: receipt['transaction_id'],
          ReceiptItem.transactionDate: receipt['transaction_date'],
          ReceiptItem.materials: receipt['materials'],
          ReceiptItem.points: receipt['total_points'],
          ReceiptItem.status: receipt['claiming_status'],
          ReceiptItem.type: receipt['claiming_type'],
        };
        ref.read(receiptProvider.notifier).saveReceipt(receiptData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BarcodeResult(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

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
        title: const Text('Enter transaction ID'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fetch Transaction ID',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 32, 77, 44),
                        ),
                      ),
                      Text(
                        'Please enter the transaction id on your receipt',
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 77, 44),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.receipt,
                  color: Color.fromARGB(255, 32, 77, 44),
                  size: 60,
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a transaction id';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        tansactionId = value;
                      });
                    },
                    decoration: InputDecoration(
                      label: Text(
                        'Transaction ID',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (_error != null)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (_isSending)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 100, child: LoadingLg(20)),
                      ],
                    ),
                  if (!_isSending)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 32, 77, 44),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: _onSubmit,
                        child: Text('Submit'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
