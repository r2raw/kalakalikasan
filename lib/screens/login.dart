import 'package:flutter/material.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'dart:convert';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/screens/register.dart';
import 'package:kalakalikasan/widgets/error_single.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});
  @override
  ConsumerState<Login> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  var _enteredUserCred = '';
  var _enteredUserPass = '';
  bool _isSending = false;
  String? _error;
  void _onSaveForm() async {
    try {
      final url = Uri.http(ref.read(urlProvider), 'login-mobile');
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isSending = true;
        });
        final response = await http.post(
          url,
          headers: {"Content-type": "application/json"},
          body: json.encode(
              {'userCred': _enteredUserCred, 'password': _enteredUserPass}),
        );

        if (response.statusCode >= 400) {
          final error = json.decode(response.body)['error'];
          setState(() {
            _error = error;
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
        }

        if (response.statusCode == 200) {
          final currentUser = json.decode(response.body)['userData'];
          final userId = currentUser['id'];
          final userData = currentUser['data'];
          final userRole = userData['role'];
          final resData = {
            CurrentUser.id: userId,
            CurrentUser.firstName: userData['firstname'],
            CurrentUser.middleName: userData['middlename'],
            CurrentUser.lastName: userData['lastname'],
            CurrentUser.email: userData['email'],
            CurrentUser.username: userData['username'],
            CurrentUser.mobileNum: userData['mobile_num'],
            CurrentUser.birthdate: userData['birthdate'],
            CurrentUser.street: userData['street'],
            CurrentUser.barangay: userData['barangay'],
            CurrentUser.city: userData['city'],
            CurrentUser.zip: userData['zip'],
            CurrentUser.province: userData['province'],
            CurrentUser.role: userData['role'],
            CurrentUser.sex: userData['sex'],
            CurrentUser.status: userData['status'],
          };

          ref.read(currentUserProvider.notifier).saveCurrentUser(resData);

          if (userRole == 'actor') {
            ref.read(screenProvider.notifier).swapScreen(0);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => EcoActors()));
          } else if (userRole == 'officer') {
            ref.read(screenProvider.notifier).swapScreen(0);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => CollectionOfficerScreen()));
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void _goToRegister() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => RegisterScreen()));
  }

  // void _showDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: Text('Invalid login'),
  //             content: Text('Incorrect login credentialsu'),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Okay'))
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/kalakalikasan_icon.png')
                  ],
                ),
                // Image.asset('assets/images/kalakalikasan_icon.png'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length <= 1) {
                      return 'This field is a required field!';
                    }

                    if (int.tryParse(value) == null) {
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredUserCred = value!;
                  },
                  decoration: InputDecoration(
                    label: Text(
                      'Email or mobile number',
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
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
                  onSaved: (value) {
                    _enteredUserPass = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_error != null && _error!.isNotEmpty)
                  ErrorSingle(errorMessage: _error),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 76, 43),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onSaveForm,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password',
                      style: TextStyle(color: Color.fromARGB(255, 34, 76, 43)),
                    )),
                TextButton(
                    onPressed: _goToRegister,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Color.fromARGB(255, 34, 76, 43)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
