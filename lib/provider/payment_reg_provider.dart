import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentInfo {
  mobileNum,
  accountName,
  paymentMethod,

}
class PaymentRegNotifier extends StateNotifier<Map<PaymentInfo, dynamic>> {
  PaymentRegNotifier() : super({});

  void saveStoreContact(Map<PaymentInfo, dynamic> userData) {
    state = userData;
  }
}

final paymentRegProvider =
    StateNotifierProvider<PaymentRegNotifier, Map<PaymentInfo, dynamic>>((ref) {
  return PaymentRegNotifier();
});
