import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenNotifier extends StateNotifier<int>{
  
  ScreenNotifier() : super(0);
  int swapScreen(int selectedScreen){
    return state = selectedScreen;
    
  }
}


final screenProvider = StateNotifierProvider<ScreenNotifier, int>((ref){
  return ScreenNotifier();  
});