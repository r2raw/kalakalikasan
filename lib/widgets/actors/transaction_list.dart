import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/transaction_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/actors/transaction_item.dart';
import 'package:kalakalikasan/model/transactions_data.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

final now = DateTime.now();

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  @override
  ConsumerState<TransactionList> createState() {
    return _TransactionListState();
  }
}

class _TransactionListState extends ConsumerState<TransactionList> {
  List transactionList = [];
  String? _error;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final userInfo = ref.read(currentUserProvider);
      final userRole = userInfo[CurrentUser.role];
      final userId = userInfo[CurrentUser.id];
      if (userRole != 'officer') {
        final url = Uri.https('kalakalikasan-server.onrender.com', 'transactions/$userId');

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
            transactionList = decoded;
          });
        }
      }

      if(userRole =='officer'){
        
        final url = Uri.https('kalakalikasan-server.onrender.com', 'officer-transaction/$userId');

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
            transactionList = decoded;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong!',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No transactions found!'));

    if (_isLoading) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingLg(50),
            SizedBox(
              height: 12,
            ),
            Text('Loading transactions...')
          ],
        ),
      );
    }

    if (_error != null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorSingle(errorMessage: _error),
        ],
      );
    }
    if (transactionList.isNotEmpty) {
      content = Container(
        child: ListView.builder(
            itemCount: transactionList.length,
            itemBuilder: (ctx, index) {
              final transaction = transactionList[index];

              String sign = '+';

              if (transaction['info'] == 'Product request') {
                sign = '-';
              }

              Widget transactValue = Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$sign${transaction['value']}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'assets/images/token-img.png',
                    width: 15,
                    height: 15,
                  ),
                ],
              );

              if (transaction['info'] == 'Conversion request' || transaction['info'] =='Points to cash') {
                transactValue = Text(
                  formatCurrency(transaction['value']),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              }
              BoxDecoration statusDecoration = BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green.withOpacity(0.7),
                border: Border.all(
                  color: Colors.green.withOpacity(0.8), // Border color
                  width: 1, // Border width
                ),
              );

              if (transaction['status'] == 'pending') {
                statusDecoration = BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.8), // Border color
                    width: 1, // Border width
                  ),
                );
              }
              if (transaction['status'] == 'rejected') {
                statusDecoration = BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.8), // Border color
                    width: 1, // Border width
                  ),
                );
              }

              if (transaction['status'] == 'pending') {}

              return Card(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction['info'],
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(timeAgo(transaction['date']),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ],
                          )),
                      // SizedBox(width: 130, child: Text(transaction['info'])),
                      Expanded(child: transactValue),
                      Container(
                        width: 80,
                        decoration: statusDecoration,
                        child: Text(
                          toTitleCase(transaction['status']),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
    return Container(child: content);
  }
}
