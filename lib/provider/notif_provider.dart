import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Notif { unread, read }

class NotifNotifier extends StateNotifier<Map<Notif, dynamic>> {
  NotifNotifier() : super({Notif.unread: [], Notif.read: []});

  void saveNotif(Map<Notif, dynamic> notifData) {
    state = notifData;
  }

  void reset() {
    state = {Notif.unread: [], Notif.read: []};
  }
}

final notifProvider =
    StateNotifierProvider<NotifNotifier, Map<Notif, dynamic>>((ref) {
  return NotifNotifier();
});
