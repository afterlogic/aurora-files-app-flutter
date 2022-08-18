import 'package:aurorafiles/assets/asset.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/quota.dart';
import 'package:aurorafiles/models/storage.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_widget.dart';
import 'package:aurorafiles/modules/settings/settings_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainDrawer extends StatelessWidget {
  void _showAvailableSpaceInfo(BuildContext context, Quota quota) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => StorageInfoWidget(
          fromDrawer: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = AppStore.authState;
    final filesState = AppStore.filesState;
    final settingsState = AppStore.settingsState;
    final s = Str.of(context);
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              onTap: null,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppStore.authState.friendlyName ?? "",
                        style: theme.textTheme.headline6,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Text(authState.userEmail),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Observer(builder: (_) {
              final quota = filesState.quota;
              if (filesState.quota != null) {
                return GestureDetector(
                  onTap: () => _showAvailableSpaceInfo(context, quota),
                  child: Tooltip(
                    showDuration: Duration(seconds: 2),
                    message: s.quota_using(
                      (quota.progress * 100).round().toString(),
                      quota.limitFormatted,
                    ),
                    child: LinearProgressIndicator(
                      value: quota.progress,
                      backgroundColor: theme.disabledColor.withOpacity(0.15),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  final futures = [
                    filesState.refreshQuota(),
                    filesState.onGetStorages(),
                  ];
                  return Future.wait(futures);
                },
                child: Observer(
                  builder: (_) => ListView(
                    padding: EdgeInsets.only(top: 10.0),
                    children: <Widget>[
                      ...filesState.currentStorages.map((Storage storage) {
                        if (storage.type == StorageType.encrypted &&
                            !settingsState.isParanoidEncryptionEnabled) {
                          return SizedBox.shrink();
                        }
                        bool enable = true;
                        if (filesState.isMoveModeEnabled ||
                            filesState.isShareUpload) {
                          if (storage.type == StorageType.shared) {
                            enable = false;
                          }
                        }
                        if (filesState.isMoveModeEnabled) {
                          final copyFromEncrypted = StorageTypeHelper.toEnum(
                                  filesState.filesToMoveCopy.first.type) ==
                              StorageType.encrypted;
                          if (copyFromEncrypted) {
                            if (storage.type != StorageType.encrypted) {
                              enable = false;
                            }
                          } else {
                            if (storage.type == StorageType.encrypted) {
                              enable = false;
                            }
                          }
                        }
                        final isSelected =
                            filesState.selectedStorage.type == storage.type;
                        final color =
                            isSelected ? Theme.of(context).primaryColor : null;
                        return Container(
                          child: ListTile(
                            enabled: enable,
                            selected: isSelected,
                            leading: _getStorageIcon(storage.type, color),
                            title: Text(storage.displayName),
                            onTap: () async {
                              filesState.selectedStorage = storage;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                FilesRoute.name,
                                (r) => false,
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
                          if (Navigator.canPop(context)) {
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName(FilesRoute.name),
                            );
                          }
                          Navigator.pushReplacementNamed(
                              context, FilesRoute.name,
                              arguments: FilesScreenArguments(path: ""));
                          filesState.toggleOffline(val);
                        },
                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.airplanemode_active),
                          title: Text(s.offline_mode),
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
              title: Text(s.settings),
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                Navigator.pushNamed(context, SettingsRoute.name);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStorageIcon(StorageType type, Color color) {
    switch (type) {
      case StorageType.encrypted:
        return SvgPicture.asset(Asset.svg.iconStorageEncrypted,
            width: 24, height: 24, color: color);
      case StorageType.shared:
        return SvgPicture.asset(Asset.svg.iconStorageShared,
            width: 24, height: 24, color: color);
      case StorageType.personal:
        return SvgPicture.asset(Asset.svg.iconStoragePersonal,
            width: 24, height: 24, color: color);
      case StorageType.corporate:
        return SvgPicture.asset(Asset.svg.iconStorageCorporate,
            width: 24, height: 24, color: color);
      default:
        return Icon(Icons.storage, color: color);
    }
  }
}
