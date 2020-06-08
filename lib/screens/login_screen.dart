import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/widgets/rounded_button.dart';
import 'package:flutter_uber_clone/widgets/user_text_field.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeArgs = '/login-screen';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Please Enter your email and password',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                UserTextField(
                  titleLabel: 'Enter your Email',
                  maxLength: 30,
                  icon: Icons.person_pin,
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                UserTextField(
                  titleLabel: 'Enter your password',
                  maxLength: 8,
                  icon: Icons.phonelink_lock,
                  controller: passwordController,
                  inputType: TextInputType.text,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Done',
                    onpressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signinWithEmailandPassword(
                              emailController.text.toString(),
                              passwordController.text.toString());
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/login.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.height*0.5,
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
