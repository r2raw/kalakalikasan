import 'package:flutter/material.dart';

class UserAppBar extends StatelessWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.people),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome,'),
                  Text('Juan Dela Cruz'),
                ],
              )
            ],
          ),
          Icon(Icons.notifications),
        ],
      ),
    );
  }
}
