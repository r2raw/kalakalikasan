import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/navigations.dart';
import 'package:kalakalikasan/model/transactions_data.dart';

const actorNav = [
  ActorNav(navIcon: Icons.home_outlined, index: 0),
  ActorNav(navIcon: Icons.dashboard_outlined, index: 1),
  ActorNav(navIcon: Icons.newspaper_outlined, index: 2),
];

final now = DateTime.now();





final transactionHistory = [
  TransactionsData(
      type: TransactionType.withdraw, date: DateTime.parse('2024-11-19'), value: 200),
  TransactionsData(type: TransactionType.buy, date: now, value: 40),
  TransactionsData(type: TransactionType.withdraw, date: now, value: 430),
  TransactionsData(type: TransactionType.sell, date: now, value: 100),
  TransactionsData(type: TransactionType.deposit, date: now, value: 41
  ),
  TransactionsData(
      type: TransactionType.sell, date: DateTime.parse('2024-11-21'), value: 200),
  TransactionsData(
      type: TransactionType.withdraw, date: DateTime.parse('2024-11-21'), value: 200),
  TransactionsData(
      type: TransactionType.withdraw, date: DateTime.parse('2024-11-21'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-11-21'), value: 200),
  TransactionsData(
      type: TransactionType.deposit, date: DateTime.parse('2024-11-19'), value: 200),
  TransactionsData(
      type: TransactionType.deposit, date: DateTime.parse('2024-11-18'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-11-20'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-07-20'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-11-20'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-09-20'), value: 200),
  TransactionsData(
      type: TransactionType.buy, date: DateTime.parse('2024-10-20'), value: 200),
];
