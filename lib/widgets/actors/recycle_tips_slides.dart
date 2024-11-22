import 'package:flutter/material.dart';

class RecycleTipsSlides extends StatelessWidget {
  const RecycleTipsSlides({super.key, required this.onTabSelect});
  
  final void Function(int index) onTabSelect;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 30, 150),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recycling Tips and  Guide',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 34, 76, 43),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {onTabSelect(2);},
                    child: Text(
                      'See more >>',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 34, 76, 43),
                      ),
                    ))
                // Text(
                //   'See more >',
                // style: TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.w600,
                //   color: Color.fromARGB(255, 34, 76, 43),
                // ),
                // ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/images/how-to-recycle.png',
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/images/how-to-recycle.png',
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
