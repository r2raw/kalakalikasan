import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ManualCollect {
  petBottle,
  can,
  userId,
}

class ManualCollectNotifier extends StateNotifier<Map<ManualCollect, dynamic>> {
  ManualCollectNotifier() : super({});

  void saveCurrentUser(Map<ManualCollect, dynamic> userData) {
    state = {...state, ...userData};
  }

  void reset(){
    state = {};
  }
}

final manualCollectProvider =
    StateNotifierProvider<ManualCollectNotifier, Map<ManualCollect, dynamic>>(
        (ref) {
  return ManualCollectNotifier();
});
