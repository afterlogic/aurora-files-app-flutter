import 'package:aurorafiles/store/app_state.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FileViewerRepository {
  Future<String> downloadFile(String url, String fileName) async {
    final dir = await DownloadsPathProvider.downloadsDirectory;

    return FlutterDownloader.enqueue(
      url: SingletonStore.instance.hostName + url,
      savedDir: dir.path,
      fileName: fileName,
      headers: {'Authorization': 'Bearer ${SingletonStore.instance.authToken}'},
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
