import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
import 'package:flutter_uber_clone/screens/user_data_signup.dart';
import 'package:flutter_uber_clone/widgets/rounded_button.dart';
import 'package:flutter_uber_clone/widgets/user_text_field.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class VerifyScreen extends StatelessWidget {
  static const routeArgs = '/verify-screen';
  final controller = TextEditingController();

  showSnackBar(msg, color, context) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: new Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: color,
      ),
    );
  }

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

  verifyOTP(BuildContext context){
    try {
      Provider.of<AuthProvider>(context, listen: false)
          .verifyOTP(controller.text.toString())
          .then((_) {
        Navigator.of(context)
            .pushReplacementNamed(UserDataSignup.routeArgs);
      }).catchError((e) {
        String errorMsg =
            'Cant authentiate you Right now, Try again later!';
        if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
          errorMsg = "Session expired, please resend OTP!";
        } else if (e
            .toString()
            .contains("ERROR_INVALID_VERIFICATION_CODE")) {
          errorMsg = "You have entered wrong OTP!";
        }
        _showErrorDialog(context, errorMsg);
      });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
                  controller: controller,
                  inputType: TextInputType.phone,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Verify Code',
                    onpressed: () {
                     verifyOTP(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/verifyimg.png',
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
