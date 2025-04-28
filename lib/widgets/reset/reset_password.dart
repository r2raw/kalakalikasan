import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/reset_otp_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/otp.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key, required this.goToStep});
  final void Function(int step) goToStep;
  @override
  ConsumerState<ResetPassword> createState() {
    return _ResetPassword();
  }
}

class _ResetPassword extends ConsumerState<ResetPassword> {
  String? _error;
  bool _isSending = false;
  String email = '';
  final _formKey = GlobalKey<FormState>();
  void _onReset() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });
        final otp = generateRandomCode();
        final url = Uri.https('kalakalikasan-server.onrender.com', 'get-email');

        final response = await http.post(url,
            headers: {'Content-type': 'application/json'},
            body: json.encode({
              'email': email,
              'otpCode': otp,
            }));

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _error = decoded['error'];
            _isSending = false;
          });

          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
        }

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          final resetOtp = {
            Reset.email: email,
            Reset.userId: decoded['id'],
            Reset.otp: otp,
          };

          ref.read(resetProvider.notifier).setOtp(resetOtp);
          widget.goToStep(2);
        }
      }
    } catch (e, stackTrace) {
      print('ERROR: $e , STACKTRACE: $stackTrace');
      setState(() {
        _error = null;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ooops, Something went wrong. $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.fingerprint,
          size: 60,
          color: Color.fromARGB(255, 32, 77, 44),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Forgot password?',
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
          'No worries, we will send you reset instructions.',
          style: TextStyle(
            color: Color.fromARGB(255, 32, 77, 44),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length <= 1) {
                    return 'This field is a required field!';
                  }

                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(pattern);

                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
                decoration: InputDecoration(
                  label: Text(
                    'Email',
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 38, 167, 72)),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ErrorSingle(errorMessage: _error),
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
                  onPressed: _onReset,
                  child: const Text(
                    'Reset password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
