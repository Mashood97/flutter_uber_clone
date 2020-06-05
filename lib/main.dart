import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
import 'package:flutter_uber_clone/screens/auth_screen.dart';
import 'package:flutter_uber_clone/screens/verify_screen.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';
import './provider/home_provider.dart';

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
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'oswald',
          primaryColor: Colors.black,
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
        home: AuthScreen(),
        routes: {
          VerifyScreen.routeArgs: (ctx) => VerifyScreen(),
          HomePage.routeArgs: (ctx) => HomePage(),
        },
      ),
    );
  }
}
