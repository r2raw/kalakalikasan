import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalakalikasan/widgets/actors/daily_schedule.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({super.key});
  @override
  State<WeeklySchedule> createState() {
    // TODO: implement createState
    return _WeeklyScheduleState();
  }
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  DateTime now = DateTime.now();

  int _currentWeekIndex = 0;

  @override
  Widget build(BuildContext context) {
    int currentWeekDay = now.weekday;
    int daysToSubtract = currentWeekDay - 1;
    DateTime startOfWeek = now.subtract(Duration(days: daysToSubtract));
    List<DateTime> weekDates = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index + (7 * _currentWeekIndex)));
    });

    // TODO: implement build

    // return Container(
    //   width: 400,
    //   child: GridView.builder(

    //       itemCount: 1,
    //       gridDelegate:
    //           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
    //       itemBuilder: (ctx, index) => DailySchedule(
    //           dayName: dayFormat.format(weekDates[index]),
    //           dayDate: weekDates[index].day.toString())),
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _currentWeekIndex > 0 ? IconButton(
          onPressed: () {
            setState(() {
              _currentWeekIndex--;
            });
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 10,
        ) : SizedBox(width: 50,),
        ...weekDates.map(
          (day) => DailySchedule(
            date: day,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentWeekIndex++;
            });
          },
          icon: Icon(Icons.arrow_forward_ios),
          iconSize: 10,
        ),
      ],
    );
  }
}
