import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Reset { otp, email, userId }

class ResetNotifier extends StateNotifier<Map<Reset, dynamic>> {
  ResetNotifier() : super({});

  void setOtp(Map<Reset, dynamic> resetInfo) {
    state = resetInfo;
  }
}

final resetProvider =
    StateNotifierProvider<ResetNotifier, Map<Reset, dynamic>>((ref) {
  return ResetNotifier();
});
