import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/schedule_list.dart';
import 'package:kalakalikasan/widgets/actors/weekly_schedule.dart';

class CollectionSchedulesScreen extends StatelessWidget {
  const CollectionSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        title: const Text('Collection Schedule'),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            children: [
              WeeklySchedule(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ScheduleList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
