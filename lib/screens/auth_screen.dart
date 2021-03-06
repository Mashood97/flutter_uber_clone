import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uber_clone/screens/login_screen.dart';
import 'package:flutter_uber_clone/screens/verify_screen.dart';
import '../widgets/user_text_field.dart';
import '../widgets/rounded_button.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final controller = TextEditingController();

  String selectedCountryCode = '';
  String selectedCountryCodeName = '';

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

  verifyPhone(BuildContext context) {
    try {
      Provider.of<AuthProvider>(context, listen: false)
          .verifyPhone(selectedCountryCodeName, selectedCountryCode,
              selectedCountryCode + controller.text.toString())
          .then((value) {
        Navigator.of(context).pushNamed(VerifyScreen.routeArgs);
      }).catchError((e) {
        String errorMsg = 'Cant Authenticate you, Try Again Later';
        if (e.toString().contains(
            'We have blocked all requests from this device due to unusual activity. Try again later.')) {
          errorMsg = 'Please wait as you have used limited number request';
        }
        _showErrorDialog(context, errorMsg);
      });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.dialCode;
    selectedCountryCodeName = countryCode.code;
    print("New Country selected: " + selectedCountryCodeName);
//    print("New Country selected: " + selectedCountryCode);
  }

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
                        'Register Now',
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
                CountryCodePicker(
                  initialSelection: selectedCountryCode,
                  onChanged: _onCountryChange,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                ),
                UserTextField(
                  titleLabel: 'Enter your number',
                  maxLength: 10,
                  icon: Icons.smartphone,
                  controller: controller,
                  inputType: TextInputType.phone,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Send OTP',
                    onpressed: () {
                      verifyPhone(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    title: 'Login Instead',
                    onpressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeArgs);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/authimage.png',
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
