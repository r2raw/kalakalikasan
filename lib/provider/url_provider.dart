import 'package:flutter_riverpod/flutter_riverpod.dart';

final urlProvider = Provider((ref) {
  return '192.168.1.2:8080';
  // return 'localhost:8080';
});
