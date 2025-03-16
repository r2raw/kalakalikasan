import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/widgets/confirm_password.dart';
import 'package:kalakalikasan/widgets/new_passsword.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() {
    return _ChangePassword();
  }
}

class _ChangePassword extends ConsumerState<ChangePassword> {
  bool _isConfirmed = false;

  void _changeScreen() {
    setState(() {
      _isConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ConfirmPassword(changeScreen: _changeScreen,);

    if(_isConfirmed){
      content = NewPasssword();
    }
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Change password'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        child: content,
      ),
    );
  }
}
