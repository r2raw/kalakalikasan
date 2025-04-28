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

  int? getUserAge() {
    final birthdateData = state[CurrentUser.birthdate];

    if (birthdateData == null) {
      return null;
    }

    try {
      DateTime birthdate;

      if (birthdateData is int) {
        // If birthdate is stored as a Firebase Timestamp (milliseconds since epoch)
        birthdate = DateTime.fromMillisecondsSinceEpoch(birthdateData);
      } else if (birthdateData is String) {
        // If birthdate is stored as an ISO 8601 string
        birthdate = DateTime.parse(birthdateData);
      } else {
        return null; // Unsupported format
      }

      final now = DateTime.now();
      int age = now.year - birthdate.year;

      // Adjust if birthday hasn't occurred yet this year
      if (now.month < birthdate.month ||
          (now.month == birthdate.month && now.day < birthdate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('Invalid birthdate format: $e');
      return null;
    }
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, Map<CurrentUser, dynamic>>(
        (ref) {
  return CurrentUserNotifier();
});
