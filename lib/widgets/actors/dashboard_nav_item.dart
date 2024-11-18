import 'package:flutter/material.dart';

class DashboardNavItem extends StatelessWidget {
  const DashboardNavItem({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration:  BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),

          ),
          child: Icon(Icons.star),
        ),
        Text('Nav Title'),
      ],
    );
  }
}
