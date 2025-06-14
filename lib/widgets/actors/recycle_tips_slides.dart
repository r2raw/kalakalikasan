import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/widgets/actors/home_carousel.dart';

class RecycleTipsSlides extends ConsumerWidget {
  const RecycleTipsSlides({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.read(currentUserProvider)[CurrentUser.role];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 30, 150),
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
                    onPressed: () {
                      if (userRole == 'officer') {
                        ref.read(screenProvider.notifier).swapScreen(2);
                        return;
                      }
                      ref.read(screenProvider.notifier).swapScreen(3);
                    },
                    child: Text(
                      'See more >>',
                      style: TextStyle(
                        fontSize: 12,
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
          HomeCarousel(),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Card(
          //         clipBehavior: Clip.hardEdge,
          //         child: Image.asset(
          //           'assets/images/how-to-recycle.png',
          //           width: 300,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 20,
          //       ),
          //       Card(
          //         clipBehavior: Clip.hardEdge,
          //         child: Image.asset(
          //           'assets/images/how-to-recycle.png',
          //           width: 300,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
