import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/order_request.dart';


enum UserQr{
  userId,
  firstName,
  lastName,
  points,
}
class UserQrNotifier extends StateNotifier<Map<UserQr, dynamic>> {
  UserQrNotifier() : super({});

  void loadUserQr(Map<UserQr, dynamic> userInfo) {
    state = userInfo;
  }

  void reset(){
    state = {};
  }
}

final userQrProvider =
    StateNotifierProvider<UserQrNotifier, Map<UserQr, dynamic>>((ref) {
  return UserQrNotifier();
});
