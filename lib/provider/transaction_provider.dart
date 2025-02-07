import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';

final transactionProvider = Provider((ref){
  return transactionHistory;
});