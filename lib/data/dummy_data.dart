import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/model/material.dart';
import 'package:kalakalikasan/model/navigations.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:kalakalikasan/model/recyclable_materials.dart';
import 'package:kalakalikasan/model/schedule.dart';
import 'package:kalakalikasan/model/transactions_data.dart';


const actorNav = [
  ActorNav(navIcon: Icons.home_outlined, index: 0),
  // ActorNav(navIcon: Icons.dashboard_outlined, index: 1),
  ActorNav(navIcon: Icons.qr_code_scanner_outlined, index: 4),
  ActorNav(navIcon: Icons.newspaper_outlined, index: 3),
];

const partnerNav = [
  ActorNav(navIcon: Icons.home_outlined, index: 0),
  // ActorNav(navIcon: Icons.dashboard_outlined, index: 1),
  ActorNav(navIcon: Icons.qr_code_scanner_outlined, index: 4),
  ActorNav(navIcon: Icons.storefront, index: 2),
  ActorNav(navIcon: Icons.newspaper_outlined, index: 3),
];

const officerNav = [
  ActorNav(navIcon: Icons.home_outlined, index: 0),
  ActorNav(navIcon: Icons.qr_code_scanner_outlined, index: 1),
  ActorNav(navIcon: Icons.newspaper_outlined, index: 2),
];

final now = DateTime.now();

final transactionHistory = [
  TransactionsData(
      type: TransactionType.withdraw,
      date: DateTime.parse('2024-11-19'),
      value: 200),
  TransactionsData(type: TransactionType.buy, date: now, value: 40),
  TransactionsData(type: TransactionType.withdraw, date: now, value: 430),
  TransactionsData(type: TransactionType.sell, date: now, value: 100),
  TransactionsData(type: TransactionType.deposit, date: now, value: 41),
  TransactionsData(
      type: TransactionType.sell,
      date: DateTime.parse('2024-11-21'),
      value: 200),
  TransactionsData(
      type: TransactionType.withdraw,
      date: DateTime.parse('2024-11-21'),
      value: 200),
  TransactionsData(
      type: TransactionType.withdraw,
      date: DateTime.parse('2024-11-21'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-11-21'),
      value: 200),
  TransactionsData(
      type: TransactionType.deposit,
      date: DateTime.parse('2024-11-19'),
      value: 200),
  TransactionsData(
      type: TransactionType.deposit,
      date: DateTime.parse('2024-11-18'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-11-20'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-07-20'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-11-20'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-09-20'),
      value: 200),
  TransactionsData(
      type: TransactionType.buy,
      date: DateTime.parse('2024-10-20'),
      value: 200),
];

final collectionScheduleData = [
  Schedule(
    barangayName: 'Commonwealth',
    collectionDate: DateTime.parse('2024-11-29'),
    startTime: DateTime.parse('8:00'),
    endTime: DateTime.parse('9:00'),
  ),
  Schedule(
    barangayName: 'Batasan',
    collectionDate: DateTime.parse('2024-11-29'),
    startTime: DateTime.parse('9:00'),
    endTime: DateTime.parse('10:00'),
  ),
  Schedule(
    barangayName: 'Holy Spirit',
    collectionDate: DateTime.parse('2024-11-29'),
    startTime: DateTime.parse('8:00'),
    endTime: DateTime.parse('9:00'),
  ),
  Schedule(
    barangayName: 'Bag-bag',
    collectionDate: DateTime.parse('2024-11-29'),
    startTime: DateTime.parse('8:00'),
    endTime: DateTime.parse('9:00'),
  ),
];

const materialsData = [
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'Assorted PP',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'HDPE Blow Clear',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'HDPE Blow Colored',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PET Clear',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PET Green',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PET Bluish',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'Single Use Plastic',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'Acryliconitrile Butadiene Styrene (ABS)',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PVC pipe black',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PVC pipe blue',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PVC pipe orange',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
  RecyclableMaterials(
    waste_type: 'Plastic',
    material_name: 'PVC-tarpaulin',
    dirty: 1,
    clean: 10,
    minimumKg: 1,
  ),
];

const dummyCart = [
  {
    'store_name': 'Lolit shop',
    'items': [
      {
        'item_name': 'Fudgee Barr',
        'quantity': 2,
        'price': 8,
      },
      {
        'item_name': 'Kopiko',
        'quantity': 1,
        'price': 15,
      }
    ]
  },
  {
    'store_name': 'AAAA shop',
    'items': [
      {
        'item_name': 'Sardines',
        'quantity': 2,
        'price': 25,
      }
    ]
  },
  {
    'store_name': 'Lolit shop',
    'items': [
      {
        'item_name': 'Fudgee Barr',
        'quantity': 2,
        'price': 8,
      },
      {
        'item_name': 'Kopiko',
        'quantity': 1,
        'price': 15,
      }
    ]
  },
  {
    'store_name': 'AAAA shop',
    'items': [
      {
        'item_name': 'Sardines',
        'quantity': 2,
        'price': 25,
      }
    ]
  },
  {
    'store_name': 'Lolit shop',
    'items': [
      {
        'item_name': 'Fudgee Barr',
        'quantity': 2,
        'price': 8,
      },
      {
        'item_name': 'Kopiko',
        'quantity': 1,
        'price': 15,
      }
    ]
  },
  {
    'store_name': 'AAAA shop',
    'items': [
      {
        'item_name': 'Sardines',
        'quantity': 2,
        'price': 25,
      }
    ]
  }
];

 