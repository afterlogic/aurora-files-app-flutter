import 'package:aurorafiles/models/files_type.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/auth/state/auth_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    final _filesState = Provider.of<FilesState>(context);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              selected: _filesState.currentFilesType == FilesType.personal,
              leading: Icon(Icons.person),
              title: Text('Personal files'),
              onTap: () {
                _filesState.setCurrentFilesType(FilesType.personal);
                _filesState.onGetFiles();
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _filesState.currentFilesType == FilesType.corporate,
              leading: Icon(Icons.group),
              title: Text('Corporate files'),
              onTap: () {
                _filesState.setCurrentFilesType(FilesType.corporate);
                _filesState.onGetFiles();
                Navigator.pop(context);
              },
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
