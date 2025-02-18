import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';

class FloatingNav extends ConsumerWidget {
  const FloatingNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 32, 77, 44),
            //  const Color.fromARGB(255, 0, 131, 89),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (ref.read(currentUserProvider)[CurrentUser.role] == 'actor')
              for (final navItem in actorNav)
                IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    iconSize: 40,
                  ),
                  onPressed: () {
                    if (navItem.index == 1) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => UserDrawer()));
                      return;
                    }
                    ref.read(screenProvider.notifier).swapScreen(navItem.index);
                  },
                  icon: Icon(navItem.navIcon),
                ),
            if (ref.read(currentUserProvider)[CurrentUser.role] == 'partner')
              for (final navItem in partnerNav)
                IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    iconSize: 40,
                  ),
                  onPressed: () {
                    if (navItem.index == 1) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => UserDrawer()));
                      return;
                    }
                    ref.read(screenProvider.notifier).swapScreen(navItem.index);
                  },
                  icon: Icon(navItem.navIcon),
                )
          ],
        ),
      ),
    );
  }
}
