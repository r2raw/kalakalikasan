import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/order_request.dart';

class OtpNotifier extends StateNotifier<String> {
  OtpNotifier() : super('');

  void setOtp(String otp) {
    state = otp;
  }

}

final otpProvider =
    StateNotifierProvider<OtpNotifier, String>((ref) {
  return OtpNotifier();
});
