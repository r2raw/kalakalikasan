import 'package:flutter/material.dart';

class ErrorArr extends StatelessWidget {
  const ErrorArr({super.key, required this.errors});
  final List errors;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(color: Color.fromARGB(255, 255, 207, 207)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...errors.map((error) => Text(
                '* $error',
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
