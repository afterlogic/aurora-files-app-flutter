import 'package:aurorafiles/database/app_database.dart';

class FileUtils {
  static String getFileNameFromPath(String path) {
    final List<String> pathList = path.split("/");
    return pathList.last;
  }

  static Object getHeroTag(LocalFile file) {
    return file.localId != -1
        ? file.localId
        : file.guid ?? file.hash;
  }
}
