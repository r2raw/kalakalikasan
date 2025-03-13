import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/notif_provider.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/barcode_result.dart';
import 'package:kalakalikasan/screens/eco_partners/user_trade_request.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:http/http.dart' as http;

const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

class NotificationItem extends ConsumerWidget {
  const NotificationItem({
    super.key,
    required this.notifId,
    required this.isRead,
    required this.notifTitle,
    required this.message,
    required this.notifDate,
    required this.redirectType,
    required this.redirectId,
  });
  final String notifId;
  final String notifTitle;
  final String message;
  final Map<String, dynamic> notifDate;
  final bool isRead;
  final String redirectType;
  final String redirectId;

  void readNotif(WidgetRef ref, BuildContext context) async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url = Uri.https('kalakalikasan-server.onrender.com', 'view-notif');
      final response = await http.patch(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode({'notifId': notifId, 'userId': userId}),
      );
      final decoded = json.decode(response.body);

      if (response.statusCode >= 400) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded['error'])));
      }
    } catch (e, stackTrace) {
      print('error: $e');
      print('stackTrace: $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong!')));
    }
  }

  void _onRead(WidgetRef ref, BuildContext context) {
    try {
      print('print $redirectType');
      if (redirectType == 'receipt') {
        _receiptNotif(ref, context);
      } else if (redirectType == 'refund' ||
          redirectType == 'selling' ||
          redirectType == 'bought') {
        _productReqNotif(context);
      }

      if (!isRead) {
        readNotif(ref, context);
      }
    } catch (e) {
      print(e);
    }
  }

  void _productReqNotif(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => UserTradeRequestScreen(orderId: redirectId)));
  }

  void _receiptNotif(WidgetRef ref, BuildContext context) async {
    final url = Uri.https(
        'kalakalikasan-server.onrender.com', 'get-receipt/$redirectId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final receipt = decoded['receipt'];

      final receiptData = {
        ReceiptItem.transactionId: receipt['transaction_id'],
        ReceiptItem.transactionDate: receipt['transaction_date'],
        ReceiptItem.materials: receipt['materials'],
        ReceiptItem.points: receipt['total_points'],
        ReceiptItem.status: receipt['claiming_status'],
        ReceiptItem.type: receipt['claiming_type'],
      };

      print(
        receipt['total_points'],
      );
      ref.read(receiptProvider.notifier).saveReceipt(receiptData);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => BarcodeResult(),
        ),
      );
      // Navigator.push(
      //   context,
      // MaterialPageRoute(
      //   builder: (ctx) => BarcodeResult(),
      // ),
      // );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isRead
            ? Theme.of(context).canvasColor
            : Theme.of(context).highlightColor,
      ),
      child: InkWell(
        onTap: () {
          _onRead(ref, context);
        },
        child: Row(
          children: [
            Icon(
              Icons.mail_outline,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            textTruncate(notifTitle, 27),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                      Text(
                        timeAgo(notifDate),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
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
