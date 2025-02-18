import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = Provider((ref) {
  return [
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
});
