import 'dart:io';

import 'package:crypto_stream/algorithm/pgp.dart';

class LegacyPgpApi {
  Pgp pgp;
  File temp;
  List<String> publicKeys;
  String? privateKey;

  LegacyPgpApi({
    required this.pgp,
    required this.temp,
    required this.publicKeys,
    this.privateKey,
  });

  double progress = 0;
  Sink<List<int>>? _sink;

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
      await (_sink?.add(data) as Future);
    }).last;
    await (_sink?.close() as Future);
    await writeStream.last;
  }

  Future close() {
    return _sink?.close() as Future;
  }

  encryptSymmetric(String content, String password) {
    return pgp.bufferPlatformSink(
      content,
      pgp.symmetricallyEncrypt(
        temp,
        password,
        content.length,
      ),
    );
  }

  Future<String> encryptBytes(String text, String password) {
    return pgp.bufferPlatformSink(
      text,
      pgp.encrypt(privateKey, publicKeys, password),
    );
  }
}
