import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/notif_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/widgets/notification/notification_filter.dart';
import 'package:kalakalikasan/widgets/notification/notification_item.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _NotificationScreen();
  }
}

class _NotificationScreen extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final notifs = ref.read(notifProvider);
    final unreadNotifs = notifs[Notif.unread];
    final readNotifs = notifs[Notif.read];

    // TODO: implement build

    Widget content = Center(child: Text('No notifications found.'));

    if (readNotifs.length > 0 || unreadNotifs.length > 0) {
      content = Column(
        children: [
          NotificationFilter(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (unreadNotifs.length > 0)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Unread notifications',
                              ),
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Text('Mark all as read'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.mark_as_unread_outlined),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (final item in unreadNotifs)
                          NotificationItem(
                            notifId: item['id'],
                            notifTitle: item['title'],
                            message: item['message'],
                            notifDate: item['notif_date'],
                            redirectType: item['redirect_type'],
                            redirectId: item['redirect_id'],
                            isRead: false,
                          )
                      ],
                    ),
                  if (readNotifs.length > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        'All notifications.',
                      ),
                    ),
                  for (final item in readNotifs)
                    NotificationItem(
                      notifId: item['id'],
                      notifTitle: item['title'],
                      message: item['message'],
                      notifDate: item['notif_date'],
                      redirectType: item['redirect_type'],
                      redirectId: item['redirect_id'],
                      isRead: true,
                    )
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text('Notification'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
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
            // gradient: LinearGradient(
            //   colors: [
            //     Color.fromARGB(255, 141, 253, 120),
            //     Color.fromARGB(255, 0, 131, 89)
            //   ],
            //   begin: Alignment.centerRight,
            //   end: Alignment.centerLeft,
            // ),
            ),
        child: Container(
          height: double.infinity,
          // decoration: const BoxDecoration(
          //   color: Color.fromARGB(255, 242, 244, 247),
          // ),
          child: content,
        ),
      ),
    );
  }
}
