import 'package:flutter_riverpod/flutter_riverpod.dart';


class ScanNotifier extends StateNotifier<String> {
  ScanNotifier() : super('');

  void saveScannedId(String id) {
    state = id;
  }
}

final scanProvider =
    StateNotifierProvider<ScanNotifier, String>((ref) {
  return ScanNotifier();
});
