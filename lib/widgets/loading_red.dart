import 'package:flutter/material.dart';

class LoadingRed extends StatelessWidget {
  
  const LoadingRed(this.circleSize, {super.key});
  final double circleSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}