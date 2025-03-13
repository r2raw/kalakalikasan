import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/landing_screen_provider.dart';
import 'package:kalakalikasan/provider/register_step_provider.dart';
import 'package:kalakalikasan/provider/registration_form_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kalakalikasan/screens/login.dart';
import 'package:kalakalikasan/widgets/error_arr.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class StepThree extends ConsumerStatefulWidget {
  const StepThree({super.key});
  @override
  ConsumerState<StepThree> createState() {
    return _StepThree();
  }
}

class _StepThree extends ConsumerState<StepThree> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _seePass = false;
  bool _seeConfPass = false;
  String username = '';
  String email = '';
  String mobileNum = '';
  String confirmPassword = '';
  List? errors;
  bool _isSending = false;
  @override
  void initState() {
    super.initState();
    final regForm = ref.read(registrationFormProvider);
    setState(() {
      username = regForm[RegInput.username]!;
      email = regForm[RegInput.email]!;
      mobileNum = regForm[RegInput.mobileNum]!;
      _passwordController.text = regForm[RegInput.password]!;
      confirmPassword = regForm[RegInput.confirmPassword]!;
    });
  }

  void _onSaveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref
          .read(registrationFormProvider.notifier)
          .updateRegForm(RegInput.username, username);
      ref
          .read(registrationFormProvider.notifier)
          .updateRegForm(RegInput.email, email);
      ref
          .read(registrationFormProvider.notifier)
          .updateRegForm(RegInput.mobileNum, mobileNum);
      ref
          .read(registrationFormProvider.notifier)
          .updateRegForm(RegInput.password, _passwordController.text);
      ref
          .read(registrationFormProvider.notifier)
          .updateRegForm(RegInput.confirmPassword, confirmPassword);
      final regForm = ref.read(registrationFormProvider);

      final Map<String, String> regFormData = regForm.map(
        (key, value) {
          // Convert RegInput enum to string key
          return MapEntry(key.toString().split('.').last, value);
        },
      );
      try {
        setState(() {
          errors = null;
          _isSending = true;
        });
        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'register-actor');
        final response = await http.post(
          url,
          headers: {"Content-type": "application/json"},
          body: json.encode(regFormData),
        );
        if (response.statusCode >= 400) {
          final responseData = await json.decode(response.body);
          setState(() {
            _isSending = false;
            errors = responseData['errors'];
          });
        }
        if (response.statusCode == 200) {
          ref.read(registrationFormProvider.notifier).resetForm();
          ref.read(registerStepProvider.notifier).goToStep(1);

          ref.read(landingScreenProvider.notifier).swapScreen(0);
        }
      } catch (err) {
        setState(() {
          errors = ['Something went wrong'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Setup your',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
            Text(
              'credentials',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Color.fromARGB(255, 33, 77, 44),
              ),
            ),
          ],
        ),
        if (errors != null && errors!.isNotEmpty) ErrorArr(errors: errors!),
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r"\s")),
                         // Blocks spaces
                  ],
                  initialValue: username,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required!';
                    }

                    if (value.contains(' ')) {
                      return 'Username must not have spaces';
                    }
                    if (value.length < 6) {
                      return 'Username must have at least 6 characters';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      username = value!;
                    });
                  },
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 77, 44),
                  ),
                  decoration: InputDecoration(
                    label: Text(
                      'Username',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
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
                  initialValue: email,
                  onSaved: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.contains(' ')) {
                      return 'Email must not have spaces';
                    }

                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);

                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 77, 44),
                  ),
                  decoration: InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
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
                  initialValue: mobileNum,
                  validator: (value) {
                    final RegExp phMobileRegex = RegExp(r"^09\d{9}$");
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    // Validate the mobile number using the regex
                    if (!phMobileRegex.hasMatch(value)) {
                      return 'Please enter a valid mobile number starting with 09';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      mobileNum = value!;
                    });
                  },
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 77, 44),
                  ),
                  decoration: InputDecoration(
                    label: Text(
                      'Mobile No.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
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
                      'Password',
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
              ],
            )),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    overlayColor: Color.fromARGB(255, 38, 167, 72)),
                onPressed: () {
                  ref.read(registerStepProvider.notifier).prevStep();
                },
                child: Text('<< Previous',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 77, 44),
                    ))),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        _isSending
            ? LoadingLg(24)
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 34, 76, 43),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _onSaveForm,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ))
      ],
    );
  }
}
