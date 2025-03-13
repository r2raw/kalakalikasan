import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/payment_reg_provider.dart';
import 'package:kalakalikasan/provider/points_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class Conversion extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _Conversion();
  }
}

class _Conversion extends ConsumerState<Conversion> {
  int _amount = 0;
  bool _isSending = false;
  final _formKey = GlobalKey<FormState>();
  void _onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        final storeId = ref.read(userStoreProvider)[UserStore.id];
        final userId = ref.read(currentUserProvider)[CurrentUser.id];

        setState(() {
          _isSending = true;
        });
        final url = Uri.https('kalakalikasan-server.onrender.com', 'request-payment');
        final response = await http.post(url,
            headers: {'Content-type': 'application/json'},
            body: json.encode({
              'store_id': storeId,
              'amount': _amount,
              'userId': userId,
              'type': ref.read(paymentRegProvider)[PaymentInfo.paymentMethod],
            }));

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _isSending = false;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(decoded['error'])));
        }

        if (response.statusCode == 200) {
          setState(() {
            _isSending = false;
          });
          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentInfo = ref.read(paymentRegProvider);
    // TODO: implement build

    Widget paymentMethod = Image.asset(
      'assets/images/gcashLogo.png',
      width: 80,
      height: 20,
    );

    if (paymentInfo[PaymentInfo.paymentMethod] == 'maya') {
      paymentMethod = Image.asset(
        'assets/images/mayaLogo.png',
        width: 80,
        height: 20,
      );
    }

    return Center(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eco-Coin Conversion',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Convert your Eco-Coins to real money!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'The minimum amount for conversion is 100 EC.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account Name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      textTruncate(paymentInfo[PaymentInfo.accountName], 20),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mobile Number',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      paymentInfo[PaymentInfo.mobileNum],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Type',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    paymentMethod
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  initialValue: _amount.toString(),
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length <= 1 ||
                        int.tryParse(value) == null ||
                        int.parse(value) < 100) {
                      return 'Enter a valid integer greater than or equal 100';
                    }

                    if (int.parse(value) > ref.read(pointsProvider)) {
                      return 'Insufficient points';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = int.parse(value!);
                  },
                  decoration: InputDecoration(
                    suffix: Image.asset(
                      'assets/images/token-img.png',
                      width: 20,
                      height: 20,
                    ),
                    label: Text(
                      'Amount',
                      style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                if (_isSending)
                  SizedBox(width: 100, height: 40, child: LoadingLg(20)),
                if (!_isSending)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 32, 77, 44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _onSubmit,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
