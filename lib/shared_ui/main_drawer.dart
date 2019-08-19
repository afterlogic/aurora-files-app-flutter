import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/screens/auth/auth_route.dart';
import 'package:aurorafiles/screens/auth/state/auth_state.dart';
import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    final _filesState = Provider.of<FilesState>(context);

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -5,
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Text("VO",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(right: 45.0),
                              child: Text(
                                "v.osovskii@afterlogic.com",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ..._filesState.currentStorages.map((Storage storage) {
                    return Container(
                      color: _filesState.selectedStorage.type == storage.type
                          ? Theme.of(context).selectedRowColor
                          : null,
                      child: ListTile(
                        selected: _filesState.selectedStorage.type == storage.type,
                        title: Text(storage.displayName),
                        onTap: () {
                          _filesState.selectedStorage = storage;
                          _filesState.onGetFiles(path: "");
                          Navigator.pop(context);
                        },
                      ),
                    );
                  })
                ],
              ),
            ),
            Divider(
              height: 0,
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
