import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';

class OfficerFloatingNav extends ConsumerStatefulWidget {
  const OfficerFloatingNav({super.key, required this.onTabSelect});
  final void Function(int index) onTabSelect;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _OfficerFloatingNav();
  }
}

class _OfficerFloatingNav extends ConsumerState<OfficerFloatingNav> {
  @override
  Widget build(BuildContext context) {
    final currentScreenIndex = ref.watch(screenProvider);
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            // color: Color.fromARGB(255, 32, 77, 44),
            //  const Color.fromARGB(255, 0, 131, 89),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final navItem in officerNav)
              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: currentScreenIndex == navItem.index
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).colorScheme.onPrimary,
                  iconSize: 40,
                ),
                onPressed: () {
                  widget.onTabSelect(navItem.index);
                },
                icon: Icon(navItem.navIcon),
              )
          ],
        ),
      ),
    );
  }
}
