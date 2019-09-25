import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/settings/settings_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
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
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => filesState.onGetStorages(),
                child: Observer(
                  builder: (_) => ListView(
                    padding: EdgeInsets.only(top: 10.0),
                    children: <Widget>[
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
                        value: filesState.isOfflineMode,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (bool val) async {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(FilesRoute.name),
                          );
                          Navigator.pushReplacementNamed(
                              context, FilesRoute.name,
                              arguments: FilesScreenArguments(path: ""));
                          filesState.toggleOffline(val);
                        },
                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.airplanemode_active),
                          title: Text("Offline mode"),
                        ),
                      ),
//                  SwitchListTile.adaptive(
//                    value: false,
//                    activeColor: Theme.of(context).accentColor,
//                    onChanged: (bool val) {},
//                    title: ListTile(
//                      contentPadding: EdgeInsets.zero,
//                      leading: Icon(Icons.link),
//                      title: Text("Public links"),
//                    ),
//                  ),
                    ],
                  ),
                ),
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
