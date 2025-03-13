import 'package:flutter_riverpod/flutter_riverpod.dart';


class ConversionScreenNotifier extends StateNotifier<int> {
  ConversionScreenNotifier() : super(0);

  void setScreen(int screen) {
    state = screen;
  }
}

final conversionScreenProvider =
    StateNotifierProvider<ConversionScreenNotifier, int>((ref) {
  return ConversionScreenNotifier();
});
