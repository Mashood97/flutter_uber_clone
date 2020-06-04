import 'package:flutter/material.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';
import './provider/home_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeProvider(),
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
            iconTheme: IconThemeData(
              color: Colors.black
            )
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
