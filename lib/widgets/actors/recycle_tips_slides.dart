import 'package:flutter/material.dart';

class RecycleTipsSlides extends StatelessWidget {
  const RecycleTipsSlides({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Recycling Tips and  Guide'), Text('See more..')],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/how-to-recycle.png',
                  width: 300,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 20,),
                Image.asset(
                  'assets/images/how-to-recycle.png',
                  width: 300,
                  fit: BoxFit.cover,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
