import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;

class FirstTimeLog extends ConsumerStatefulWidget {
  const FirstTimeLog({super.key});

  @override
  ConsumerState<FirstTimeLog> createState() {
    return _FirstTimeLog();
  }
}

class _FirstTimeLog extends ConsumerState<FirstTimeLog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String? _error;
  bool _seePass = false;
  bool _isSending = false;
  bool _seeConfPass = false;
  String confirmPassword = '';

  void _onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });
        final url = Uri.https('kalakalikasan-server.onrender.com', 'first-time-log');
        final userId = ref.read(currentUserProvider)[CurrentUser.id];
        final response = await http.post(
          url,
          headers: {'Content-type': 'application/json'},
          body: json.encode(
            {
              'id': userId,
              'password': confirmPassword,
            },
          ),
        );

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
          setState(() {
            _isSending = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => CollectionOfficerScreen(),
            ),
          );

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              content: Text(
                'Password changed successfully!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Ooops, Something went wrong ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome officer,',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'As it is your first time logging in, we require you to set up your desired password first to secure your account.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.password,
                    color: Theme.of(context).primaryColor,
                    size: 60,
                  )
                ],
              ),
              Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            obscureText: !_seePass,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }

                              if (value.length < 8) {
                                return 'Password should have 8 characters minimum';
                              }
                              final passwordRegex = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$');

                              if (!passwordRegex.hasMatch(value)) {
                                return 'Password must include:\n1 uppercase letter, 1 number, and 1 symbol';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Color.fromARGB(244, 32, 77, 44)),
                            decoration: InputDecoration(
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _seePass = !_seePass;
                                    });
                                  },
                                  icon: !_seePass
                                      ? Icon(
                                          Clarity.eye_hide_line,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Clarity.eye_show_line,
                                          color: Theme.of(context).primaryColor,
                                        )),
                              label: Text(
                                'Password',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 33, 77, 44),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 38, 167, 72),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            //Confirm password
                            initialValue: confirmPassword,
                            obscureText: !_seeConfPass,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required!';
                              }

                              if (_passwordController.text != value) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                confirmPassword = value!;
                              });
                            },
                            style: TextStyle(
                                color: Color.fromARGB(244, 32, 77, 44)),
                            decoration: InputDecoration(
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _seeConfPass = !_seeConfPass;
                                    });
                                  },
                                  icon: !_seeConfPass
                                      ? Icon(
                                          Clarity.eye_hide_line,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Clarity.eye_show_line,
                                          color: Theme.of(context).primaryColor,
                                        )),
                              label: Text(
                                'Confirm Password',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 33, 77, 44),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 38, 167, 72),
                                  width: 2,
                                ),
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
                                backgroundColor:
                                    Color.fromARGB(255, 32, 77, 44),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _onSubmit,
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
