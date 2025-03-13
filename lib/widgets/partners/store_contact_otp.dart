import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/conversion_screen_provider.dart';
import 'package:kalakalikasan/provider/otp_provider.dart';
import 'package:kalakalikasan/provider/payment_reg_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class StoreContactOtp extends ConsumerStatefulWidget {
  const StoreContactOtp({super.key});

  @override
  ConsumerState<StoreContactOtp> createState() {
    // TODO: implement createState
    return _StoreContactOtp();
  }
}

class _StoreContactOtp extends ConsumerState<StoreContactOtp> {
  final List<String> _otp = List.filled(6, "");
  bool _isSending = false;
  String? _error;
  void _updateOtp(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
  }

  void _submitOtp() async {
    String otpCode = _otp.join();
    final sentOtp = ref.read(otpProvider);
    if (otpCode != sentOtp) {
      setState(() {
        _error = 'Invalid OTP';
      });

      return;
    }

    try {

      setState(() {
        _isSending = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com', 'linked-wallet');
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final paymentInfo = ref.read(paymentRegProvider);

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'storeId': storeId,
            'accountName': paymentInfo[PaymentInfo.accountName],
            'mobileNum': paymentInfo[PaymentInfo.mobileNum],
            'type': paymentInfo[PaymentInfo.paymentMethod],
          }));

      final decoded = json.decode(response.body);

      if (response.statusCode >= 400) {
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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('You have successfully linked your wallet!')));

        final Map<PaymentInfo, dynamic> registeredWallet = {
          PaymentInfo.accountName: decoded['accountName'],
          PaymentInfo.mobileNum: decoded['mobileNum'],
          PaymentInfo.paymentMethod: decoded['type'],
        };

        ref.read(paymentRegProvider.notifier).saveStoreContact(registeredWallet);
        ref.read(conversionScreenProvider.notifier).setScreen(2);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Oops! Something went wrong, please try again later.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneNum = ref.read(paymentRegProvider)[PaymentInfo.mobileNum];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_android_outlined,
              size: 60,
              color: Color.fromARGB(255, 32, 77, 44),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Verification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 32, 77, 44),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              textAlign: TextAlign.center,
              'We sent a code to $phoneNum',
              style: TextStyle(
                color: Color.fromARGB(255, 32, 77, 44),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    height: 64,
                    width: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          _updateOtp(index, value);
                          if (index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_error != null)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            SizedBox(
              height: 16,
            ),
            if(_isSending)LoadingLg(30),
            if(!_isSending)ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 32, 77, 44),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _submitOtp,
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(conversionScreenProvider.notifier).setScreen(0);
              },
              label: Text('Resend OTP'),
            ),
            SizedBox(
              height: 4,
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(conversionScreenProvider.notifier).setScreen(0);
              },
              label: Text('Go back'),
              icon: Icon(Icons.keyboard_return),
            )
          ],
        ),
      ),
    );
  }
}
