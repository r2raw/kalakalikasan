import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointsNotifier extends StateNotifier<int>{
  
  PointsNotifier() : super(0);
  int updatePoints(int currentPoints){
    return state = currentPoints;
    
  }
}


final pointsProvider = StateNotifierProvider<PointsNotifier, int>((ref){
  return PointsNotifier();  
});