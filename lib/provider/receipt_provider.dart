import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReceiptItem {
  transactionId,
  transactionDate,
  materials,
  points,
  status,
  type
}
class ReceiptNotifier extends StateNotifier<Map<ReceiptItem, dynamic>> {
  ReceiptNotifier() : super({});

  void saveReceipt(Map<ReceiptItem, dynamic> receiptData) {
    state = receiptData;
  }

  void resetReceipt(){
    state = {};
  }
}

final receiptProvider =
    StateNotifierProvider<ReceiptNotifier, Map<ReceiptItem, dynamic>>((ref) {
  return ReceiptNotifier();
});
