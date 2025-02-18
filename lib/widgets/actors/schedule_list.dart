import 'package:flutter/material.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, index) => Card(
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.pin_drop,
                size: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(style: TextStyle(fontSize: 24), 'Barangay Name'),
                  Text(style: TextStyle(fontSize: 16), '8:00 AM - 9:00 AM')
                ],
              ),
              Expanded(
                  child: Icon(
                Icons.fire_truck,
                size: 50,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
