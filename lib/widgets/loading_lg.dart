import 'package:flutter/material.dart';

class LoadingLg extends StatelessWidget {
  const LoadingLg(this.circleSize, {super.key});
  final double circleSize;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SizedBox(
        width: circleSize,
        height: circleSize,
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 38, 167, 72),
        ),
      ),
    );
  }
}
