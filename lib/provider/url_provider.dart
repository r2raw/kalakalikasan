import 'package:flutter_riverpod/flutter_riverpod.dart';

final urlProvider = Provider((ref) {
  return '192.168.100.82:8080';
  // return '192.168.93.162:8080';
  // return 'localhost:8080';
});
