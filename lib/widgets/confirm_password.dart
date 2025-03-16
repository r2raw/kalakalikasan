import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;

class ConfirmPassword extends ConsumerStatefulWidget {
  const ConfirmPassword({super.key, required this.changeScreen});
  final VoidCallback changeScreen;
  @override
  ConsumerState<ConfirmPassword> createState() {
    return _ConfirmPassword();
  }
}

class _ConfirmPassword extends ConsumerState<ConfirmPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _seePass = false;
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isLoading = true;
        });

        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'confirm-password');
        final userId = ref.read(currentUserProvider)[CurrentUser.id];
        final response = await http.post(
          url,
          headers: {'Content-type': 'application/json'},
          body: json.encode(
            {'id': userId, 'password': _passwordController.text},
          ),
        );

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _isLoading = false;
            _error = decoded['error'];
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
          return;
        }

        if(response.statusCode == 200){
          widget.changeScreen();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops, Something went wrong!',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'To protect your account, we require you to confirm your password before making changes.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.key,
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
                    return 'Please enter your current password';
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
                    'Confirm password',
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
                  child: Text('Confirm'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
