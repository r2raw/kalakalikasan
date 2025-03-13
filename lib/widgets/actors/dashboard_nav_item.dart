import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';

class DashboardNavItem extends ConsumerWidget {
  const DashboardNavItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.screen});
  final IconData icon;
  final String title;
  final Widget screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.read(currentUserProvider)[CurrentUser.role];
    return InkWell(
      onTap: () {
        if(title == 'Collect Materials'){
          ref.read(manualCollectProvider.notifier).reset();
          ref.read(userQrProvider.notifier).reset();
        }
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => screen));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 194, 194, 194),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: role == 'actor' ? 11: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
