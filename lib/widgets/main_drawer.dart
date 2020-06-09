import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
import 'package:flutter_uber_clone/screens/home.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            height: 150,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: <Widget>[
                Text(
                  'PickUp',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(HomePage.routeArgs),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => {},
//                Navigator.of(context)
//                .pushReplacementNamed(OrdersOverviewScreen.routeArgs),
            title: Text(
              'My Rides',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.directions_car,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
