import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/auth/state/auth_state.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AuthState();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal files'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Corporate files'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () {
                authState.onLogout();
                Navigator.pushReplacementNamed(context, AuthRoute.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
