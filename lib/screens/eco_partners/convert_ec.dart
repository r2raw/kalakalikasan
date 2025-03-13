import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/conversion_screen_provider.dart';
import 'package:kalakalikasan/provider/payment_reg_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/partners/conversion.dart';
import 'package:kalakalikasan/widgets/partners/payment_reg.dart';
import 'package:kalakalikasan/widgets/partners/store_contact_otp.dart';
import 'package:http/http.dart' as http;

class ConvertEcScreen extends ConsumerStatefulWidget {
  const ConvertEcScreen({super.key});

  @override
  ConsumerState<ConvertEcScreen> createState() {
    return _ConvertEcScreen();
  }
}

class _ConvertEcScreen extends ConsumerState<ConvertEcScreen> {
  bool _isFetching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      setState(() {
        _isFetching = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com',
          'linked-wallet/${ref.read(userStoreProvider)[UserStore.id]}');
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode >= 400) {
        setState(() {
          _isFetching = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(decoded['error'])));
      }

      if (response.statusCode == 200) {
        setState(() {
          _isFetching = false;
        });
        if (!decoded['hasWallet']) {
          ref.read(conversionScreenProvider.notifier).setScreen(0);
          return;
        }

        final walletInfo = {
          PaymentInfo.accountName: decoded['accountName'],
          PaymentInfo.mobileNum: decoded['mobileNum'],
          PaymentInfo.paymentMethod: decoded['type'],
        };

        ref.read(paymentRegProvider.notifier).saveStoreContact(walletInfo);
        ref.read(conversionScreenProvider.notifier).setScreen(2);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Ooops! Something went wrong, Please try again later.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    // TODO: implement build

    final currentScreen = ref.watch(conversionScreenProvider);
    Widget content = Text('No data found!');

    if (_isFetching) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingLg(60),
            SizedBox(height: 12,),
            Text(
              'Fetching wallet info!',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
          ],
        ),
      );
    }

    if (!_isFetching) {
      if (currentScreen == 0) {
        content = PaymentReg();
      }
      if (currentScreen == 1) {
        content = StoreContactOtp();
      }
      if (currentScreen == 2) {
        content = Conversion();
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
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
          title: const Text('Convert EC'),
        ),
        body: Container(
          width: w,
          height: h,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
          child: SingleChildScrollView(
              child: SizedBox(height: 650, child: Center(child: content))),
        ));
  }
}
