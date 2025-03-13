import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Rates {
  petCoins,
  petPoints,
  canCoins,
  canPoints
}
class CurrentUserNotifier extends StateNotifier<Map<Rates, int>> {
  CurrentUserNotifier() : super({});

  void saveRates(Map<Rates, int> rates) {
    state = rates;
  }
}

final ratesProvider =
    StateNotifierProvider<CurrentUserNotifier, Map<Rates, int>>((ref) {
  return CurrentUserNotifier();
});
