import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/model/transactions_data.dart';
import 'package:kalakalikasan/widgets/actors/transaction_list.dart';
import 'package:kalakalikasan/widgets/under_construction.dart';

final now = DateTime.parse('2007-12-30');

class UserTransactionsScreen extends StatelessWidget {
  const UserTransactionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double h = MediaQuery.of(context).size.height;
    List<TransactionsData> trasaction_history = [];
    double w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
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
        title: const Text('Transactions'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Filter'),
                  ElevatedButton(onPressed: () {}, child: Text('Date')),
                  ElevatedButton(onPressed: () {}, child: Text('Type'))
                ],
              ),
              TransactionList(
                transactions: transactionHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
