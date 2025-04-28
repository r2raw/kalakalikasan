import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialScreenProvider extends StateNotifier<int> {
  TutorialScreenProvider() : super(0);
  int swapScreen(int selectedScreen) {
    return state = selectedScreen;
  }

  int nextScreen() {
    return state = state + 1;
  }
}

final tutorialScreenProvider =
    StateNotifierProvider<TutorialScreenProvider, int>((ref) {
  return TutorialScreenProvider();
});
