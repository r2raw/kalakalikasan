import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/landing_screen_provider.dart';
import 'package:kalakalikasan/provider/notif_provider.dart';
import 'dart:convert';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/screens/collection_officer/first_time_log.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/screens/forgot_password.dart';
import 'package:kalakalikasan/screens/register.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});
  @override
  ConsumerState<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<Login> {
  bool _seePass = true;
  final _formKey = GlobalKey<FormState>();
  var _enteredUserCred = '';
  var _enteredUserPass = '';
  bool _isSending = false;
  String? _error;
  void _onSaveForm() async {
    try {
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'login-mobile');
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ref.read(notifProvider.notifier).reset();
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
            _isSending = false;
            _error = error;
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
        }

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          final currentUser = decoded['userData'];

          // final store = decoded['store'];

          // if(store){

          // }
          final userId = currentUser['id'];
          final userData = currentUser['data'];
          final userRole = userData['role'];
          final currentStore = decoded['store'];
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

          if (userRole != 'officer') {
            if (currentStore != null) {
              final Map<UserStore, dynamic> storeData = {
                UserStore.id: currentStore[0]['id'],
                UserStore.storeName: currentStore[0]['store_name'],
                UserStore.storeLogo: currentStore[0]['store_logo'],
                UserStore.street: currentStore[0]['street'],
                UserStore.barangay: currentStore[0]['barangay'],
                UserStore.city: currentStore[0]['city'],
                UserStore.province: currentStore[0]['province'],
                UserStore.zip: currentStore[0]['zip'],
                UserStore.dtiPermit: currentStore[0]['dti_permit'],
                UserStore.barangayPermit: currentStore[0]['barangay_permit'],
                UserStore.storeImage: currentStore[0]['store_image'],
                UserStore.applicationDate: currentStore[0]['application_date'],
                UserStore.rejectionDate: currentStore[0]['date_rejection'],
                UserStore.rejectionReason: currentStore[0]['rejection_reason'],
                UserStore.status: currentStore[0]['status'],
              };

              ref.read(userStoreProvider.notifier).saveStore(storeData);
            }
            setState(() {
              _isSending = false;
            });
            ref.read(screenProvider.notifier).swapScreen(0);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => EcoActors()));
          } else if (userRole == 'officer') {
            ref.read(screenProvider.notifier).swapScreen(0);
            if (userData['first_time_log']) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => FirstTimeLog(),
                ),
              );
              return;
            }
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
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (ctx) => RegisterScreen()));
    ref.read(landingScreenProvider.notifier).swapScreen(2);
  }

  void _goToPasswordReset() {
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (ctx) => ForgotPasswordScreen()));
    ref.read(landingScreenProvider.notifier).swapScreen(1);
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
    final landingScreen = ref.watch(landingScreenProvider);
    Widget content = Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Image.asset('assets/icons/basura_bot_text.png'),
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
                      return 'This field is required!';
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _seePass,
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _seePass = !_seePass;
                          });
                        },
                        icon: _seePass
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
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (_isSending) LoadingLg(20),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: _goToPasswordReset,
                    style: TextButton.styleFrom(
                        overlayColor: Color.fromARGB(255, 38, 167, 72),
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    child: Text('Forgot password')),
                TextButton(
                    style: TextButton.styleFrom(
                        overlayColor: Color.fromARGB(255, 38, 167, 72),
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    onPressed: _goToRegister,
                    child: Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );

    if (landingScreen == 1) {
      content = ForgotPasswordScreen();
    }

    if (landingScreen == 2) {
      content = RegisterScreen();
    }
    return content;
  }
}
