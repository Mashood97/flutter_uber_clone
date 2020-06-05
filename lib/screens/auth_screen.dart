import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone/screens/verify_screen.dart';
import '../widgets/user_text_field.dart';
import '../widgets/rounded_button.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        'Please enter your number below',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )),
                UserTextField(
                  titleLabel: 'Enter your number',
                  maxLength: 13,
                  icon: Icons.smartphone,
                  controller: controller,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Send OTP',
                    onpressed: () {
                      Provider.of<AuthProvider>(context)
                          .verifyNo(controller.text.toString());
                      Navigator.of(context).pushNamed(VerifyScreen.routeArgs);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/authimage.png',
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
