import 'package:aurorafiles/database/app_database.dart';

class FileUtils {
  static String getFileNameFromPath(String path) {
    final List<String> pathList = path.split("/");
    return pathList.last;
  }

  static Object getHeroTag(LocalFile file) {
    return file.localId != -1 ? file.localId : file.guid ?? file.hash;
  }

  static String reduceFilePath({
    required String path,
    required String delimiterText,
    String overflowText = '...',
  }) {
    final overflowSplit = path.split(overflowText);
    final hasReduced = overflowSplit.length > 1;
    final endCropped = overflowSplit.length == 2 && overflowSplit.last.isEmpty;
    if (hasReduced && !endCropped) {
      ///example: 'folder_1/...der_4/folder_5/folder_6/folder_7/'
      ///cut in the middle
      final cropLength = overflowSplit[0].length + overflowText.length + 1;
      final croppedText = path.substring(cropLength);
      return overflowSplit[0] + overflowText + croppedText;
    }

    final delimiterSplit = path.split(delimiterText);
    final oneDirLevel = delimiterSplit.length < 2;
    var cropLength = overflowText.length + 1;
    final shortSecondDirLevel =
        delimiterSplit.length == 2 && delimiterSplit.last.length < cropLength;
    if (endCropped || oneDirLevel || shortSecondDirLevel) {
      ///example: 'long_long_long_long_long_long_long_long_folder_name...'
      ///example: 'long_long_long_long_long_long_long_long_folder_name/...'
      ///example: 'long_long_long_long_long_long_long_long_folder_name'
      ///example: 'long_long_long_long_long_long_long_long_folder_name/'
      ///example: 'long_long_long_long_long_long_long_long_folder_name/f2
      ///cut in the end
      final croppedText = path.substring(0, path.length - cropLength);
      return croppedText + overflowText;
    }

    ///example: '/folder_1/folder_2/folder_3/folder_4/folder_5/folder_6/folder_7'
    ///example: '/long_long_long_long_long_long_long_long_folder_name/folder_2';
    ///example: '/folder_1/long_long_long_long_long_long_long_long_folder_name';
    ///example: 'long_long_long_long_long_folder_name_1/long_long_long_long_long_folder_name_2'
    ///cut in the middle
    cropLength = delimiterSplit[0].length +
        delimiterText.length +
        overflowText.length +
        1;
    final croppedText = path.substring(cropLength);
    return delimiterSplit[0] + delimiterText + overflowText + croppedText;
  }

  static List<LocalFile> getFilesFromFolder(
    List<LocalFile> allFiles,
    String folderPath,
  ) {
    if (allFiles.isEmpty) {
      return [];
    }
    final result = <LocalFile>[];
    for (var file in allFiles) {
      if (file.path == folderPath) {
        result.add(file);
      }
    }
    return result;
  }
}
