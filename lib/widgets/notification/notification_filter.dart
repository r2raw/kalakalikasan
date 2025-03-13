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
          Text(
            'Filter',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: () {},
                    child: Text('All'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: () {},
                    child: Text('Transactions'),
                  ),
                  SizedBox(
                    width: 10,
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
