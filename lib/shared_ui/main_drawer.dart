import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/settings/settings_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = AppStore.authState;
    final filesState = AppStore.filesState;
    final settingsState = AppStore.settingsState;

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
//                        Positioned(
//                          right: -10,
//                          bottom: -5,
//                          child: IconButton(
//                            icon: Icon(Icons.settings),
//                            color: Colors.white,
//                            onPressed: () {},
//                          ),
//                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Text(authState.userEmail[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
//                              padding: const EdgeInsets.only(right: 45.0),
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                authState.userEmail,
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
                  ...filesState.currentStorages.map((Storage storage) {
                    if (storage.type == "encrypted" &&
                        !settingsState.isParanoidEncryptionEnabled) {
                      return SizedBox();
                    }
                    return Container(
                      color: filesState.selectedStorage.type == storage.type
                          ? Theme.of(context).selectedRowColor
                          : null,
                      child: ListTile(
                        selected:
                            filesState.selectedStorage.type == storage.type,
                        leading: Icon(Icons.storage),
                        title: Text(storage.displayName),
                        onTap: () async {
                          // close drawer
                          Navigator.of(context).pop();
                          // clear nav stack TODO: make more flexible
                          Navigator.of(context)
                              .popUntil((Route<dynamic> route) {
                            return route.isFirst;
                          });
                          // set new storage and reload files
                          filesState.selectedStorage = storage;
                          Navigator.of(context).pushReplacementNamed(
                            FilesRoute.name,
                            arguments: FilesScreenArguments(
                              path: "",
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  Divider(),
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (bool val) {},
                    title: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.airplanemode_active),
                      title: Text("Offline mode"),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (bool val) {},
                    title: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.link),
                      title: Text("Public links"),
                    ),
                  ),
//                  SwitchListTile.adaptive(
//                    value: Theme.of(context).brightness == Brightness.dark,
//                    onChanged: (bool val) {},
//                    title: ListTile(
//                      contentPadding: EdgeInsets.zero,
//                      leading: Icon(MdiIcons.themeLightDark),
//                      title: Text("Dark theme"),
//                    ),
//                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, SettingsRoute.name);
              },
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
