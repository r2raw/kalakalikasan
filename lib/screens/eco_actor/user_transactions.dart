import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/widgets/actors/transaction_list.dart';

final now = DateTime.parse('2007-12-30');

class UserTransactionsScreen extends StatelessWidget {
  const UserTransactionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
        title: const Text('Transactions'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       // Color.fromARGB(255, 141, 253, 120),
        //       // Color.fromARGB(255, 0, 131, 89)
        //       Color.fromARGB(255, 72, 114, 50),
        //       Color.fromARGB(255, 32, 77, 44)
        //     ],
        //     begin: Alignment.centerRight,
        //     end: Alignment.centerLeft,
        //   ),
        // ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      'Transaction History',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    // Text(
                    //   'View your recent transaction history.',
                    //   style: Theme.of(context).textTheme.headlineSmall,
                    // ),
                    // Text(
                    //   'Tap on any details to see additional details.',
                    //   style: Theme.of(context).textTheme.headlineSmall,
                    // )
                  ]),
                  Icon(
                    MingCute.history_line,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            Expanded(
                child: Card(
              elevation: 5,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                  padding: EdgeInsets.only(top: 20), child: TransactionList()),
            )),
          ],
        ),
      ),
    );
  }
}
