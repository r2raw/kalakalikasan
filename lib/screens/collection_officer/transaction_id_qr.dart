import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/screens/collection_officer/home_barcode_scan.dart';

class TransactionIdQrScreen extends ConsumerStatefulWidget {
  const TransactionIdQrScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TransactionIdQrScreen();
  }
}

class _TransactionIdQrScreen extends ConsumerState<TransactionIdQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColor,
          title: Text('Enter transaction'),
          centerTitle: true,
        ),
        body: HomeBarcodeScanScreen());
  }
}
