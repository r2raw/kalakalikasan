import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() {
    // TODO: implement createState
    return _loginState();
  }
}

class _loginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/kalakalikasan_icon.png'),
            Column(
              children: [
                const TextField(
                  decoration:
                      InputDecoration(label: Text('Email or mobile number')),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text('Password'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ],
            ),
            const Column(
              children: [Text('Forgot password'), Text('Register')],
            )
          ],
        ),
      ),
    );
  }
}
