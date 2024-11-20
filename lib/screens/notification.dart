import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/notification/notification_filter.dart';
import 'package:kalakalikasan/widgets/notification/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: InkWell(
        //       borderRadius: BorderRadius.circular(50),
        //       onTap: () {},
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        //         decoration: const BoxDecoration(),
        //         child: const Row(
        //           children: [
        //             Text('Mark all as read'),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Icon(Icons.mark_as_unread_outlined),
        //           ],
        //         ),
        //       ),
        //     ),
        //   )
        // ],
        title: const Text('Notification'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 141, 253, 120),
              Color.fromARGB(255, 0, 131, 89)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 242, 244, 247),
          ),
          child: const Column(
            children: [
              NotificationFilter(),
              Expanded(
                child: SingleChildScrollView(
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Unread notifications',
                            ),
                            Row(
                              children: [
                                Text('Mark all as read'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.mark_as_unread_outlined),
                              ],
                            ),
                          ],
                        ),
                      ),
                      NotificationItem(
                        notifTitle: 'Schedule Update',
                        isRead: false,
                      ),
                      NotificationItem(
                        notifTitle: 'Schedule Update',
                        isRead: false,
                      ),
                      NotificationItem(
                        notifTitle: 'Schedule Update',
                        isRead: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Text(
                          'All notifications.',
                        ),
                      ),
                      NotificationItem(
                        notifTitle: 'Recieved coins',
                      ),
                      NotificationItem(
                        notifTitle: 'Withdraw',
                      ),
                      NotificationItem(
                        notifTitle: 'Schedule Update',
                      ),
                      NotificationItem(
                        notifTitle: 'Schedule Update',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
