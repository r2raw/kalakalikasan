import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';

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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.red),
        // ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/kalakalikasan_icon.png'),
              const SizedBox(
                height: 20,
              ),
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
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => EcoActors()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Forgot password'),
              Text('Register')
            ],
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: const Column(
          //     children: [Text('Forgot password'), Text('Register')],
          //   ),
        ),
      ),
    );
  }
}
