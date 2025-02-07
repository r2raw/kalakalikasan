import 'package:flutter/material.dart';

class ErrorSingle extends StatelessWidget {
  const ErrorSingle({super.key, required this.errorMessage});

  final errorMessage;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
