import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/widgets/main_drawer.dart';
import '../widgets/maps.dart';

class HomePage extends StatelessWidget {
  static const routeArgs = '/homepage';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Maps(scaffoldKey),
      drawer: MainDrawer(),
    );
  }
}

