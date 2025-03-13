import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserStore {
  id,
  storeName,
  storeLogo,
  street,
  barangay,
  city,
  province,
  zip,
  dtiPermit,
  barangayPermit,
  storeImage,
  applicationDate,
  rejectionDate,
  rejectionReason,
  status,
}

class UserStoreNotifier extends StateNotifier<Map<UserStore, dynamic>> {
  UserStoreNotifier() : super({});

  void saveStore(Map<UserStore, dynamic> userData) {
    state = userData;
  }

  void updateStore(Map<UserStore, dynamic> userData) {
    state = {...state, ...userData};
  }

  void reset() {
    state = {};
  }
}

final userStoreProvider =
    StateNotifierProvider<UserStoreNotifier, Map<UserStore, dynamic>>((ref) {
  return UserStoreNotifier();
});
