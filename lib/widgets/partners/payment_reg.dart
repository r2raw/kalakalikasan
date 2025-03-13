import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/conversion_screen_provider.dart';
import 'package:kalakalikasan/provider/otp_provider.dart';
import 'package:kalakalikasan/provider/payment_reg_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/otp.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/partners/store_contact_otp.dart';

class PaymentReg extends ConsumerStatefulWidget {
  const PaymentReg({super.key});
  @override
  ConsumerState<PaymentReg> createState() {
    // TODO: implement createState
    return _PaymentReg();
  }
}

class _PaymentReg extends ConsumerState<PaymentReg> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'gcash';
  String _moblieNum = '';
  String _accountName = '';
  bool _isSending = false;
  void _onSaveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });
      final otp = generateRandomCode();
      ref.read(otpProvider.notifier).setOtp(otp);
      try {
        if (otp.isNotEmpty) {
          final url = Uri.https('kalakalikasan-server.onrender.com', 'send-sms');
          final message =
              "[KalaKalikasan] - Your otp for registering your store's mobile number is '$otp'. If you did not request this, please ignore this message.";

          final response = await http.post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'send_to': _moblieNum,
                'msg': message,
              }));

          if (response.statusCode >= 400) {
            setState(() {
              _isSending = false;
            });
            final decoded = json.decode(response.body);
            final error = decoded['error'];

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error)));
            return;
          }

          if (response.statusCode == 200) {
            setState(() {
              _isSending = false;
            });
            ref.read(paymentRegProvider.notifier).saveStoreContact({
              PaymentInfo.accountName: _accountName,
              PaymentInfo.mobileNum: _moblieNum,
              PaymentInfo.paymentMethod: _selectedPaymentMethod,
            });

            ref.read(conversionScreenProvider.notifier).setScreen(1);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Ooops! Somethig went wrong. Please Try again later')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Link Your E-Wallet',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Register your e-wallet account to \neasilyconvert your Eco-Coins (EC) \ninto real money.',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Icon(
                    Icons.wallet,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                // initialValue: mobileNum,
                validator: (value) {
                  final RegExp phMobileRegex = RegExp(r"^09\d{9}$");
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  }
                  // Validate the mobile number using the regex
                  if (!phMobileRegex.hasMatch(value)) {
                    return 'Please enter a valid mobile number starting with 09';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    label: Text(
                  'Mobile Number',
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 77, 44),
                  ),
                )),
                onSaved: (value) {
                  setState(() {
                    _moblieNum = value!;
                  });
                },
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Account name is required!';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _accountName = value!;
                  });
                },
                decoration: InputDecoration(
                  label: Text('Account Name',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Payment method',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      activeColor: Color.fromARGB(255, 33, 77, 44),
                      fillColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 38, 167, 72)),
                      value: 'gcash',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      title: Image.asset('assets/images/gcashLogo.png'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Color.fromARGB(255, 33, 77, 44),
                      fillColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 38, 167, 72)),
                      value: 'maya',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      title: Image.asset('assets/images/mayaLogo.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              if (_isSending) LoadingLg(20),
              if (!_isSending)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 32, 77, 44),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onSaveForm,
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
