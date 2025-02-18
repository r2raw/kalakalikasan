import 'package:flutter/material.dart';

class TextErrorDefault extends StatelessWidget {
  const TextErrorDefault(this.errorMessage, {super.key});

  final errorMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Text(
        errorMessage,
        style: TextStyle(color: Color.fromARGB(255, 180, 68, 69), fontSize: 12),
      ),
    );
  }
}
