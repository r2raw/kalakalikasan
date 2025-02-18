import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/transaction_provider.dart';
import 'package:kalakalikasan/widgets/actors/transaction_item.dart';
import 'package:kalakalikasan/model/transactions_data.dart';

final now = DateTime.now();

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  // final List<TransactionsData> transactions;

  @override
  ConsumerState<TransactionList> createState() {
    // TODO: implement createState
    return _TransactionListState();
  }
}

class _TransactionListState extends ConsumerState<TransactionList> {
  List<TransactionsData> get sortedTransactions {
    // List<TransactionsData> arr = widget.transactions;
      final arr = ref.watch(transactionProvider);
      if (arr.isEmpty) return [];

      arr.sort((a, b) => b.date.compareTo(a.date));
      return arr;
  }

  @override
  Widget build(BuildContext context) {
    final List<TransactionsData> transactionsToday = sortedTransactions
        .where((transaction) => transaction.date.difference(now).inDays == 0)
        .toList();

    final List<TransactionsData> previousTransaction = sortedTransactions
        .where((transaction) => transaction.date.difference(now).inDays != 0)
        .toList();

    Widget content = Column(
      children: [
        const Text('All Transactions'),
        ...previousTransaction
            .map((transaction) => TransactionItem(transaction: transaction))
      ],
    );

    if (transactionsToday.isNotEmpty) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Today'),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Column(
            children: [
              ...transactionsToday.map(
                  (transaction) => TransactionItem(transaction: transaction)),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Previous transactions',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Column(
            children: [
              ...previousTransaction.map(
                  (transaction) => TransactionItem(transaction: transaction))
            ],
          ),
        ),
      ]);
    }
    return Expanded(
        child: SingleChildScrollView(child: Container(child: content)));
  }
}
