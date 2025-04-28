import 'package:intl/intl.dart';

DateTime converToFlutterDate() {
  return DateTime.now();
}

String timeAgo(Map<String, dynamic> timestamp) {
  int seconds = timestamp["_seconds"];
  DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  Duration difference = DateTime.now().difference(date);

  if (difference.inDays > 7) {
    return DateFormat('MM/dd/yyyy').format(date);
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hr${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return '${difference.inSeconds} sec${difference.inSeconds == 1 ? '' : 's'} ago';
  }
}


// String timeAgo(Map<String, dynamic> timestamp) {
//   int seconds = timestamp["_seconds"];
//   DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true); // Force UTC
//   DateTime now = DateTime.now().toUtc(); // Convert current time to UTC

//   Duration difference = now.difference(date);

//   if (difference.inDays > 7) {
//     return DateFormat('MM/dd/yyyy').format(date.toLocal()); // Convert back to local for display
//   } else if (difference.inDays >= 1) {
//     return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
//   } else if (difference.inHours >= 1) {
//     return '${difference.inHours} hr${difference.inHours == 1 ? '' : 's'} ago';
//   } else if (difference.inMinutes >= 1) {
//     return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
//   } else {
//     return '${difference.inSeconds} sec${difference.inSeconds == 1 ? '' : 's'} ago';
//   }
// }

String myDateTime(Map<String, dynamic> timestamp) {
  int seconds = timestamp["_seconds"];
  DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

  return DateFormat('MM/dd/yyyy - hh:mm a').format(date);
}


String dateTimeShort(Map<String, dynamic> timestamp) {
  int seconds = timestamp["_seconds"];
  DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

  return DateFormat('MM/dd/yyyy').format(date);
}

String formatCurrency(int amount) {
  // Manually set the currency symbol to ₱
  final NumberFormat currencyFormat = NumberFormat('#,##0', 'en_PH');
  return '₱${currencyFormat.format(amount)}';
}



String dateNow() {
  DateTime date = DateTime.now();

  return DateFormat('MM/dd/yyyy - hh:mm a').format(date);
}

// Map<String, dynamic> dateTimeNaNow = {
//   '_seconds': DateTime.now().millisecondsSinceEpoch ~/ 1000, // Convert to PHT
//   '_nanoseconds': (DateTime.now().microsecondsSinceEpoch % 1000000) * 1000
// };

Map<String, dynamic> dateTimeNaNow() {
  DateTime now = DateTime.now();
  int seconds = now.millisecondsSinceEpoch ~/ 1000;
  int nanoseconds = (now.microsecondsSinceEpoch % 1000000) * 1000;

  return {
    "_seconds": seconds,
    "_nanoseconds": nanoseconds,
  };
}
