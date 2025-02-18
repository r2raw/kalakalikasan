import 'package:flutter/material.dart';
import 'package:kalakalikasan/util/validation.dart';

const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {super.key,
      this.isRead,
      required this.notifTitle,
      required this.message,
      required this.notifDate});
  final String notifTitle;
  final String message;
  final Map<String, dynamic> notifDate;
  final bool? isRead;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
      decoration: BoxDecoration(
          color: isRead == null || isRead!
              ? Colors.white
              : const Color.fromARGB(255, 225, 225, 225)),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Icon(Icons.mail_outline),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(notifTitle)
                        ],
                      ),
                      Text(timeAgo(notifDate))
                    ],
                  ),
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
