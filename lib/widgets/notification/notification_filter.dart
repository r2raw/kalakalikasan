import 'package:flutter/material.dart';

class NotificationFilter extends StatelessWidget {
  const NotificationFilter({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Filter',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          Container(
            width: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('All'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Transactions'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Schedules'),
                  )
                ],
              ),
            ),
          ), 
        ],
      ),
    );
  }
}
