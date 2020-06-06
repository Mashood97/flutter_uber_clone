import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
import 'package:flutter_uber_clone/screens/home.dart';
import 'package:flutter_uber_clone/widgets/rounded_button.dart';
import 'package:flutter_uber_clone/widgets/user_text_field.dart';
import 'package:provider/provider.dart';

class UserDataSignup extends StatelessWidget {
  static const routeArgs = '/userData';

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();

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
                      'Please Fill the below form',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                UserTextField(
                  titleLabel: 'Enter your full name',
                  maxLength: 75,
                  icon: Icons.person_pin,
                  controller: nameController,
                  inputType: TextInputType.text,
                ),
                UserTextField(
                  titleLabel: 'Enter your city Name',
                  maxLength: 40,
                  icon: Icons.location_city,
                  controller: cityController,
                  inputType: TextInputType.text,
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
                      try {
                        Provider.of<AuthProvider>(context, listen: false)
                            .addUserData(
                                nameController.text.toString(),
                                cityController.text.toString(),
                                passwordController.text.toString());
                        Navigator.of(context).pushReplacementNamed(HomePage.routeArgs);
                      } catch (e) {
                        showSnackBar(e.toString(), Colors.red, context);
                      }
                    },
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
