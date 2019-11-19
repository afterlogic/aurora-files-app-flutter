import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/auth/state/auth_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/state/settings_state.dart';

class AppStore {
  static final authState = AuthState();
  static final filesState = FilesState();
  static final settingsState = SettingsState();
}
