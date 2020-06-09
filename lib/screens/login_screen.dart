import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/screens/home.dart';
import 'package:flutter_uber_clone/utils/http_exception.dart';
import 'package:flutter_uber_clone/widgets/rounded_button.dart';
import 'package:flutter_uber_clone/widgets/user_text_field.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeArgs = '/login-screen';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK!'),
          )
        ],
      ),
    );
  }

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
                    title: 'Login',
                    onpressed: () {
                      try {
                        Provider.of<AuthProvider>(context, listen: false)
                            .signinWithEmailandPassword(
                                emailController.text.toString(),
                                passwordController.text.toString())
                            .then((_) {
                          Navigator.of(context).popAndPushNamed(HomePage.routeArgs);
                        }).catchError(
                                (e) => _showErrorDialog(context, e.toString()));
                      } on HttpException catch (e) {
                        var errorMessage = 'Auth Failed';
                        if (e.toString().contains('Password isn\'t correct')) {
                          errorMessage = 'Please enter correct password';
                        } else if (e.toString().contains(
                            'Signin Failed, Please Enter Correct Credential')) {
                          errorMessage = 'Please Enter correct Credentials';
                        }
                        _showErrorDialog(context, errorMessage);
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/login.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.height * 0.5,
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
