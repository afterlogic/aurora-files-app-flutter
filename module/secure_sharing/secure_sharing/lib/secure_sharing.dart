library secure_sharing;

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/repository/files_local_storage.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/modules/settings/repository/pgp_key_util.dart';
import 'package:crypto_stream/algorithm/pgp.dart';
import 'package:flutter/widgets.dart';

abstract class SecureSharing {
  Future sharing(
    BuildContext context,
    FilesState filesState,
    LocalPgpKey? userPrivateKey,
    LocalPgpKey? userPublicKey,
    PgpKeyUtil pgpKeyUtil,
    PreparedForShare preparedForShare,
  );

  Future encryptSharing(
    BuildContext context,
    FilesState filesState,
    LocalPgpKey? userPrivateKey,
    LocalPgpKey? userPublicKey,
    PgpKeyUtil pgpKeyUtil,
    PreparedForShare preparedForShare,
    Function onUpdate,
    Pgp pgp,
  );
}
