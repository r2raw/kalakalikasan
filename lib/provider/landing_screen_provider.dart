import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreenNotifier extends StateNotifier<int>{
  
  LandingScreenNotifier() : super(0);
  int swapScreen(int selectedScreen){
    return state = selectedScreen;
    
  }
}


final landingScreenProvider = StateNotifierProvider<LandingScreenNotifier, int>((ref){
  return LandingScreenNotifier();  
});