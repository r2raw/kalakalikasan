import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/widgets/actors/transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        shrinkWrap: true,
        itemCount: transactionHistory.length,
        itemBuilder: (ctx, index) => TransactionItem(
              transaction: transactionHistory[index],
            ));
  }
}
