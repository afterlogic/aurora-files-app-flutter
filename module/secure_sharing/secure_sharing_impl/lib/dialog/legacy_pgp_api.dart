import 'dart:io';

import 'package:crypto_stream/algorithm/pgp.dart';

class LegacyPgpApi {
  Pgp pgp;
  File temp;
  String privateKey;
  List<String> publicKeys;
  Sink<List<int>> _sink;
  double progress;

  LegacyPgpApi(this.pgp);

  Future encryptFile(
    File input,
    File output,
    String password,
  ) async {
    progress = 0;
    if (await output.exists()) await output.delete();
    if (await temp.exists()) await temp.delete();

    int length = await input.length();
    int count = 0;
    final writeStream =
        pgp.encrypt(privateKey, publicKeys, password).asyncMap((data) async {
      count += data.length;
      progress = count / length;
      await output.writeAsBytes(data, mode: FileMode.append);
    });
    writeStream.listen((_) {});

    _sink = pgp.platformSink();
    await input.openRead().asyncMap((data) async {
      await (_sink.add(data) as Future);
    }).last;
    await (_sink.close() as Future);
    await writeStream.last;
  }

  Future close() {
    return _sink?.close() as Future;
  }

  encryptSymmetricFile(File file, File output, String password) {}

  Future<String> encryptBytes(String text, String password) {
    return pgp.bufferPlatformSink(
      text,
      pgp.encrypt(privateKey, publicKeys, password),
    );
  }
}
