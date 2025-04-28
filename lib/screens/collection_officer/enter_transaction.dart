import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/receipt_qr_result.dart';
import 'package:kalakalikasan/screens/collection_officer/transaction_id_qr.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class EnterTransactionScreen extends ConsumerStatefulWidget {
  const EnterTransactionScreen({super.key, required this.origin});
  final String origin;
  @override
  ConsumerState<EnterTransactionScreen> createState() {
    return _EnterTransactionScreen();
  }
}

class _EnterTransactionScreen extends ConsumerState<EnterTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  String? _error;
  String _transactionId = '';
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isSending = true;
        });
        String transId = _transactionId;

        if (_transactionId.length == 13) {
          transId = _transactionId.substring(0, 12);
        }
        final url = Uri.https(
            'kalakalikasan-server.onrender.com', '/get-receipt/$transId');
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

          if (receipt['claiming_status'] == 'completed') {
            setState(() {
              _error = 'Reciept has been claimed already';
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

          if (widget.origin == 'dashboard') {
            Navigator.of(context).pop(true);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ReceiptQrResultScreen(),
            ),
          );

          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ooops! Something wenth wrong.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Enter transaction'),
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
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fetch Transaction ID',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text(
                        "Please enter receipt's transaction ID\nto continue",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    HeroIcons.arrow_path,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a transaction ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _transactionId = value!;
                    });
                  },
                  decoration: InputDecoration(
                    label: Text(
                      'Transaction ID',
                      style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: ErrorSingle(errorMessage: _error),
                ),
              if (_isSending)
                SizedBox(
                  width: 80,
                  child: LoadingLg(20),
                ),
              if (!_isSending)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 32, 77, 44),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: _onSubmit,
                    child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
