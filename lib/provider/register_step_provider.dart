import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterStepNotifier extends StateNotifier<int> {
  RegisterStepNotifier() : super(1);
  void nextStep() {
    state = state + 1;
  }

  void prevStep() {
    state = state - 1;
  }

  void goToStep(int selectedStep) {
    state = selectedStep;
  }
}

final registerStepProvider =
    StateNotifierProvider<RegisterStepNotifier, int>((ref) {
  return RegisterStepNotifier();
});
