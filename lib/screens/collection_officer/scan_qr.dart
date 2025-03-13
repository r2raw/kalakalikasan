import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/receipt_provider.dart';
import 'package:kalakalikasan/provider/scan_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/home_barcode_scan.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/collection_officer/username_input_option.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';
import 'package:http/http.dart' as http;

class ScanQr extends ConsumerStatefulWidget {
  const ScanQr({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScanQr();
  }
}

class _ScanQr extends ConsumerState<ScanQr> {
  String? currentScreen;

  String? _error;
  void goToResult() async {
    final scannedId = ref.read(scanProvider);
    try {
      print('scanned id ${scannedId.length}');
      if (scannedId.length <= 13) {
        final url = Uri.https(
            'kalakalikasan-server.onrender.com', 'get-receipt/${scannedId}');
        final response = await http.get(url);
        final decoded = json.decode(response.body);

        final receipt = decoded['receipt'];
        if (response.statusCode >= 400) {
          if (!context.mounted) {
            return;
          }

          setState(() {
            _error = decoded['error'];
          });

          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
          // ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     backgroundColor: Theme.of(context).colorScheme.errorContainer,
          //     content: Text(
          //       decoded['error'],
          //       style: TextStyle(color: Theme.of(context).colorScheme.error),
          //     )));
        }

        if (response.statusCode == 200) {
          if (receipt['claiming_status'] == 'completed') {
            setState(() {
              _error = 'Receipt has ben claimed already!';
            });

            Future.delayed(Duration(seconds: 3), () {
              setState(() {
                _error = null;
              });
            });

            return;
          }
          final receiptData = {
            ReceiptItem.transactionId: receipt['transaction_id'],
            ReceiptItem.transactionDate: receipt['transaction_date'],
            ReceiptItem.materials: receipt['materials'],
            ReceiptItem.points: receipt['total_points'],
            ReceiptItem.status: receipt['claiming_status'],
            ReceiptItem.type: receipt['claiming_type'],
          };
          ref.read(receiptProvider.notifier).saveReceipt(receiptData);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (ctx) => HomeBarcodeScanScreen()));

          setState(() {
            currentScreen = 'barcode';
          });
        }
      }

      if (scannedId.length > 13) {
        final url = Uri.https(
            'kalakalikasan-server.onrender.com', 'qr-scan-user/$scannedId');

        final response = await http.get(url);
        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          if (!context.mounted) {
            return;
          }

          setState(() {
            _error = decoded['error'];
          });

          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
        }
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).clearSnackBars();
          final decoded = json.decode(response.body);

          final Map<UserQr, dynamic> qrInfo = {
            UserQr.firstName: decoded['firstname'],
            UserQr.lastName: decoded['lastname'],
            UserQr.points: decoded['points'],
            UserQr.userId: decoded['userId']
          };

          ref.read(userQrProvider.notifier).loadUserQr(qrInfo);
          setState(() {
            currentScreen = 'qr';
          });
          print('decoded: $decoded');
        }
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scan QR/Barcode',
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text(
                    'Place the QR/Barcode inside the area',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Scanning will start automaticallly',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Icon(
                Iconsax.scan_outline,
                color: Theme.of(context).primaryColor,
                size: 70,
              ),
            ],
          ),
          SizedBox(height: 20,),
          MyScanner(goToResult: goToResult),
          SizedBox(height: 20,),
          if (_error != null) ErrorSingle(errorMessage: _error)
        ],
      ),
    );

    if (currentScreen == 'barcode') {
      content = HomeBarcodeScanScreen();
    }

    if (currentScreen == 'qr') {
      content = QrResultScreen();
    }
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            currentScreen = null;
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: content,
        ));
  }
}
