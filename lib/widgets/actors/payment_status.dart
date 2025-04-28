import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class PaymentStatus extends ConsumerStatefulWidget {
  const PaymentStatus({super.key, required this.paymentId});
  final String paymentId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PaymentStatus();
  }
}

class _PaymentStatus extends ConsumerState<PaymentStatus> {
  String? _error;
  bool _isLoading = false;
  Map<String, dynamic> paymentData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final paymentId = widget.paymentId;
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'get-payment/$paymentId');

      final response = await http.get(url);
      final decoded = json.decode(response.body);
      if (response.statusCode >= 400) {
        setState(() {
          _error = decoded['error'];
          _isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          paymentData = decoded;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'An error occured. ERROR:$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    Widget content = Text('Data not found');

    if (_isLoading) {
      content = LoadingLg(50);
    }

    if (_error != null) {
      content = ErrorSingle(errorMessage: _error);
    }

    if (paymentData.isNotEmpty) {
      content = Card(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/basura_bot_text.png',
                  width: 60,
                  height: 60,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    toTitleCase(paymentData['status']),
                    style: TextStyle(
                      color: paymentData['status'] == 'approved'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(formatCurrency(paymentData['amount']))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (paymentData['status'] == 'approved')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date approved',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                        child: Text(
                      myDateTime(paymentData['date_approved']).toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ))
                  ],
                ),
              if (paymentData['status'] == 'rejected')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date rejected',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                        child: Text(
                      myDateTime(paymentData['rejected_date']).toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ))
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              if (paymentData['status'] == 'rejected')
                Text(
                  paymentData['rejected_reason'],
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                )
            ],
          ),
        ),
      );
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
          title: Text('Payment Status'),
        ),
        body: Container(
          width: w,
          height: h,
          padding: EdgeInsets.all(20),
          child: Center(child: content),
        ));
  }
}
