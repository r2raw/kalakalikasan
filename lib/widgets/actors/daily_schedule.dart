import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dayFormat = DateFormat.E();

class DailySchedule extends StatelessWidget {
  const DailySchedule({super.key, required this.date});

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final curr_day = dayFormat.format(date);
    // TODO: implement build
    return Column(
      children: [
        Text(curr_day),
        Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: CircleBorder(),
          child: SizedBox(
            width: 35,
            height: 35,
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        )
      ],
    );
  }
}
