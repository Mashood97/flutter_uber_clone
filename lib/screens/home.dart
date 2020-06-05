import 'package:flutter/material.dart';
import '../widgets/map.dart';

class HomePage extends StatelessWidget {
  static const routeArgs = '/homepage';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Map(scaffoldKey),
      drawer: Drawer(),
    );
  }
}

