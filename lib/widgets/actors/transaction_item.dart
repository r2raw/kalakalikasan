import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/transactions_data.dart';

final now = DateTime.now();

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});
  // final IconData icon;
  // final String type;
  final TransactionsData transaction;

  String get dayDiff {
    print('Transaction date: ${transaction.date}');
    print('Compare: ${transaction.date.compareTo(now)}');
    final diffDays = now.difference(transaction.date).inDays;
    final diffHours = now.difference(transaction.date).inHours;
    final diffMin = now.difference(transaction.date).inDays;
    String res = '';
    if (diffDays > 0 && diffDays <= 7) {
      return '$diffDays day${diffDays > 1 ? 's' : ''} ago.';
    }

    if (diffHours > 0) {
      return '$diffHours hour${diffHours > 1 ? 's' : ''} ago';
    }

    if (diffMin > 0) {
      return '$diffMin min${diffMin > 1 ? 's' : ''} ago';
    }

    return dateFormatter.format(transaction.date);
    // return res;
    // return ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        print(dayDiff);
      },
      child: Row(
        children: [
          Icon(transactionTypeIcon[transaction.type]),
          Column(
            children: [
              Text(transaction.type.name.toUpperCase()),
              Text(dayDiff),
              Column()
            ],
          )
        ],
      ),
    );
  }
}
