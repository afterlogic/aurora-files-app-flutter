import 'dart:io';

import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/auth/auth_android.dart';
import 'package:aurorafiles/modules/auth/auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/backup_code_auth/backup_code_auth_route.dart';
import 'package:aurorafiles/modules/auth/screens/backup_code_auth/backup_code_auth_widget.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor.dart';
import 'package:aurorafiles/modules/auth/screens/select_two_factor/select_two_factor_route.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_route.dart';
import 'package:aurorafiles/modules/auth/screens/trust_device/trust_device_widget.dart';
import 'package:aurorafiles/modules/auth/screens/upgrade_android.dart';
import 'package:aurorafiles/modules/files/files_android.dart';
import 'package:aurorafiles/modules/files/files_route.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_android.dart';
import 'package:aurorafiles/modules/files/screens/file_viewer/file_viewer_route.dart';
import 'package:aurorafiles/modules/settings/screens/about/about_android.dart';
import 'package:aurorafiles/modules/settings/screens/about/about_route.dart';
import 'package:aurorafiles/modules/settings/screens/common/common_android.dart';
import 'package:aurorafiles/modules/settings/screens/common/common_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_android.dart';
import 'package:aurorafiles/modules/settings/screens/encryption/encryption_route.dart';
import 'package:aurorafiles/modules/settings/screens/encryption_server_setting/encryption_server_android.dart';
import 'package:aurorafiles/modules/settings/screens/encryption_server_setting/encryption_server_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/export_pgp_key_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/export_pgp_key_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/pgp_key_model_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/key/pgp_key_model_widget.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_setting_route.dart';
import 'package:aurorafiles/modules/settings/screens/pgp/pgp_settings_widget.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_route.dart';
import 'package:aurorafiles/modules/settings/screens/storage/storage_info_widget.dart';
import 'package:aurorafiles/modules/settings/settings_android.dart';
import 'package:aurorafiles/modules/settings/settings_route.dart';
import 'package:aurorafiles/override_platform.dart';
import 'package:aurorafiles/shared_ui/fade_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'auth/screens/fido_auth/fido_auth.dart';
import 'auth/screens/fido_auth/fido_auth_route.dart';
import 'auth/screens/two_factor_auth/two_factor_auth_route.dart';
import 'auth/screens/two_factor_auth/two_factor_auth_widget.dart';
import 'auth/screens/upgrade_route.dart';

class AppNavigation {
  static String currentRoute = "/";

  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name.startsWith(FilesRoute.name)) {
      final FilesScreenArguments args = settings.arguments;
      if (PlatformOverride.isIOS && false) {
        return CupertinoPageRoute(
            settings: RouteSettings(
              name: FilesRoute.name + (args == null ? "" : args.path),
            ),
            builder: (context) => args != null
                ? FilesAndroid(
                    path: args.path,
                    isZip: args.isZip,
                  )
                : FilesAndroid());
      } else {
        return FadeRoute(
          page: args != null
              ? FilesAndroid(
                  path: args.path,
                  isZip: args.isZip,
                )
              : FilesAndroid(),
          settings: RouteSettings(
            name: FilesRoute.name + (args == null ? "" : args.path),
          ),
          duration: 150,
        );
      }
    }
    switch (settings.name) {
      case AuthRoute.name:
        return MaterialPageRoute(
            settings: RouteSettings(
              name: settings.name,
            ),
            builder: (context) => AuthAndroid());

      case FileViewerRoute.name:
        final FileViewerScreenArguments args = settings.arguments;
        if (PlatformOverride.isIOS && false) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => FileViewerAndroid(
                    immutableFile: args.file,
                    offlineFile: args.offlineFile,
                    filesState: args.filesState,
                    filesPageState: args.filesPageState,
                  ));
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: FileViewerAndroid(
                immutableFile: args.file,
                filesState: args.filesState,
                offlineFile: args.offlineFile,
                filesPageState: args.filesPageState,
              ));
        }
        break;

      case UpgradeRoute.name:
        final args = settings.arguments as UpgradeArg;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: UpgradeAndroid(args?.message),
        );
        break;
      case FidoAuthRoute.name:
        final args = settings.arguments as FidoAuthRouteArgs;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: FidoAuthWidget(args),
        );
        break;
      case SelectTwoFactorRoute.name:
        final args = settings.arguments as SelectTwoFactorRouteArgs;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: SelectTwoFactorWidget(args),
        );
        break;
      case TrustDeviceRoute.name:
        final args = settings.arguments as TrustDeviceRouteArgs;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: TrustDeviceWidget(args: args),
        );
        break;
      case BackupCodeAuthRoute.name:
        final args = settings.arguments as BackupCodeAuthRouteArgs;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: BackupCodeAuthWidget(args),
        );
        break;
      case TwoFactorAuthRoute.name:
        final args = settings.arguments as TwoFactorAuthRouteArgs;
        return FadeRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          page: TwoFactorAuthWidget(args),
        );
        break;
      case SettingsRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => SettingsAndroid());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: SettingsAndroid(),
              duration: 150);
        }
        break;

      case EncryptionRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => EncryptionAndroid());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: EncryptionAndroid(),
              duration: 150);
        }
        break;
      case PgpSettingsRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => PgpSettingWidget());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: PgpSettingWidget(),
              duration: 150);
        }
        break;
      case EncryptionServerRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => EncryptionServer());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: EncryptionServer(),
              duration: 150);
        }
        break;
      case StorageInfoRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => StorageInfoWidget());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: StorageInfoWidget(),
              duration: 150);
        }
        break;
      case PgpKeyModelRoute.name:
        final arguments = settings.arguments as List;
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) =>
                  PgpKeyModelWidget(arguments[0], arguments[1], arguments[2]));
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: PgpKeyModelWidget(arguments[0], arguments[1], arguments[2]),
              duration: 150);
        }
        break;
      case PgpKeyExportRoute.name:
        final arguments = settings.arguments as List;
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) =>
                  ExportPgpKeyWidget(arguments.first, arguments.last));
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: ExportPgpKeyWidget(arguments.first, arguments.last),
              duration: 150);
        }
        break;
      case CommonSettingsRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => CommonSettingsAndroid());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: CommonSettingsAndroid(),
              duration: 150);
        }
        break;

      case AboutRoute.name:
        if (PlatformOverride.isIOS) {
          return CupertinoPageRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              builder: (context) => AboutAndroid());
        } else {
          return FadeRoute(
              settings: RouteSettings(
                name: settings.name,
              ),
              page: AboutAndroid(),
              duration: 150);
        }
        break;
      default:
        return MaterialPageRoute(
            settings: RouteSettings(
              name: settings.name,
            ),
            builder: (context) {
              final s = Str.of(context);
              return Scaffold(
                body: Center(child: Text(s.no_route(settings.name))),
              );
            });
    }
  }
}
