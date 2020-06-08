import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/provider/auth_provider.dart';
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
                  'Shopify',
                  style: Theme.of(context).textTheme.title.copyWith(
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
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            title: Text(
              'Shop',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.shopping_basket,
              color: Theme.of(context).accentColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => {},
//                Navigator.of(context)
//                .pushReplacementNamed(OrdersOverviewScreen.routeArgs),
            title: Text(
              'Orders',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.payment,
              color: Theme.of(context).accentColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => {},
//                Navigator.of(context)
//                .pushReplacementNamed(UserProductsScreen.routeArgs),
            title: Text(
              'Manage Products',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
//                Navigator.of(context)
//                    .pushReplacementNamed(AuthScreen.routeName),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
