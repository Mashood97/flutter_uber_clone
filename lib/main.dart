import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
import 'package:flutter_uber_clone/screens/auth_screen.dart';
import 'package:flutter_uber_clone/screens/login_screen.dart';
import 'package:flutter_uber_clone/screens/user_data_signup.dart';
import 'package:flutter_uber_clone/screens/verify_screen.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';
import 'provider/home_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          supportedLocales: [
            Locale('en'),
            Locale('it'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate,
          ],
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'oswald',
            primaryColor: Colors.black,
            canvasColor: Colors.white,
            appBarTheme: AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                iconTheme: IconThemeData(color: Colors.black)),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.getAutoLogin
              ? HomePage()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen(),
                ),
          routes: {
            VerifyScreen.routeArgs: (ctx) => VerifyScreen(),
            HomePage.routeArgs: (ctx) => HomePage(),
            UserDataSignup.routeArgs: (ctx) => UserDataSignup(),
            LoginScreen.routeArgs: (ctx) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
