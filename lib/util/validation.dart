import 'package:intl/intl.dart';

DateTime converToFlutterDate (){
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
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
  }
}




String myDateTime(Map<String, dynamic> timestamp) {
  int seconds = timestamp["_seconds"];
  DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

    return DateFormat('MM/dd/yyyy - hh:mm a').format(date);
}