import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CurrentUser {
  id,
  firstName,
  middleName,
  lastName,
  email,
  username,
  mobileNum,
  street,
  zip,
  barangay,
  city,
  province,
  birthdate,
  role,
  sex,
  status,
  qr,
}
class CurrentUserNotifier extends StateNotifier<Map<CurrentUser, dynamic>> {
  CurrentUserNotifier() : super({});

  void saveCurrentUser(Map<CurrentUser, dynamic> userData) {
    state = userData;
  }
  void updateUser(Map<CurrentUser, dynamic> userData) {
    state = {...state, ...userData};
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, Map<CurrentUser, dynamic>>((ref) {
  return CurrentUserNotifier();
});
