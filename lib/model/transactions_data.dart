
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
enum TransactionType {withdraw, deposit, buy, sell}

const transactionTypeIcon = {
  TransactionType.withdraw: Icons.monetization_on,
  TransactionType.deposit: Icons.recycling,
  TransactionType.buy: Icons.accessibility,
  TransactionType.sell: Icons.sell,
};

class TransactionsData {
  const TransactionsData({required this.type, required this.date, required this.value});
  final TransactionType type;
  final DateTime date;
  final int value;
}
final dateFormatter = DateFormat.yMd();
