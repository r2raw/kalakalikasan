import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/transactions_data.dart';

final now = DateTime.now();

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});
  // final IconData icon;
  // final String type;
  final TransactionsData transaction;

  String get dayDiff {
    // print('Transaction date: ${transaction.date}');
    // print('Compare: ${transaction.date.compareTo(now)}');
    final diffDays = now.difference(transaction.date).inDays;
    final diffHours = now.difference(transaction.date).inHours;
    final diffMin = now.difference(transaction.date).inDays;
    String res = dateFormatter.format(transaction.date);
    if (diffDays > 0 && diffDays <= 7) {
      res = '$diffDays day${diffDays > 1 ? 's' : ''} ago.';
    } else if (diffHours > 0 && diffDays == 0) {
      res = '$diffHours hour${diffHours > 1 ? 's' : ''} ago';
    } else if (diffMin > 0 && diffHours == 0) {
      res = '$diffMin min${diffMin > 1 ? 's' : ''} ago';
    } else if (diffMin == 0) {
      res = 'Now';
    }

    return res;
    // return res;
    // return ;
  }

  Color get getColor {
    Color color = const Color.fromARGB(255, 16, 81, 134);
    if (transaction.type == TransactionType.buy) {
      color = const Color.fromARGB(255, 204, 163, 30);
    }
    if (transaction.type == TransactionType.deposit) {
      color = Colors.green;
    }
    if (transaction.type == TransactionType.withdraw) {
      color = const Color.fromARGB(255, 243, 97, 87);
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        print(dayDiff);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              transactionTypeIcon[transaction.type],
              size: 40,
              color: getColor,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.type.name.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: getColor),
                      ),
                      Text(
                        transaction.value.toString(),
                        // textAlign: TextAlign.end,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: getColor),
                      ),
                    ],
                  ),
                  Text(dayDiff),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
