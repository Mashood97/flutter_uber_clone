import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone/widgets/rounded_button.dart';
import 'package:flutter_uber_clone/widgets/user_text_field.dart';

import 'home.dart';

class VerifyScreen extends StatelessWidget {

  static const routeArgs = '/verify-screen';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'PickUp',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Please enter code sent to your number',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                UserTextField(
                  titleLabel: 'Enter 6 digit Code',
                  maxLength: 6,
                  icon: Icons.dialpad,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Verify Code',
                    onpressed: () {
                      Navigator.of(context).pushReplacementNamed(HomePage.routeArgs);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/verifyimg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
