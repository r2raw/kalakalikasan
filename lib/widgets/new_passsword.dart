import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;

class NewPasssword extends ConsumerStatefulWidget {
  const NewPasssword({super.key});

  @override
  ConsumerState<NewPasssword> createState() {
    return _NewPassword();
  }
}

class _NewPassword extends ConsumerState<NewPasssword> {
  final _formKey = GlobalKey<FormState>();
  bool _seePass = false;
  final _passwordController = TextEditingController();
  String confirmPassword = '';

  bool _seeConfPass = false;
  bool _isLoading = false;
  String? _error;
  void _onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        final userId = ref.read(currentUserProvider)[CurrentUser.id];
        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'change-password');
        final response = await http.post(url,
            headers: {'Content-type': 'application/json'},
            body: json.encode({'id': userId, 'password': confirmPassword}));

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _error = decoded['error'];
            _isLoading = false;
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
          return;
        }

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              content: Text(
                'Password changed successfully!',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          );

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops, Something went wrong!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'For your security, we recommend updating your password regularly',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.password,
              color: Theme.of(context).primaryColor,
              size: 60,
            )
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                    'New password',
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
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
                height: 8,
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
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
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
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ErrorSingle(errorMessage: _error),
                ),
              if (_isLoading)
                SizedBox(
                  width: 100,
                  height: 50,
                  child: LoadingLg(20),
                ),
              if (!_isLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: _onSubmit,
                  child: Text('Change password'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
