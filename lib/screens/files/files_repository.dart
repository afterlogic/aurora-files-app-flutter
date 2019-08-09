import 'dart:convert';

import 'package:aurorafiles/store/app_state.dart';
import 'package:aurorafiles/utils/get_error_message.dart';
import 'package:http/http.dart' as http;

class FilesRepository {
  final String apiUrl = SingletonStore.instance.apiUrl;
  final String authToken = SingletonStore.instance.authToken;

  Future getFiles(String type, String path, String pattern) async {
    final parameters =
        json.encode({"Type": type, "Path": path, "Pattern": pattern});

    final res = await http.post(apiUrl, headers: {
      'Authorization': 'Bearer $authToken'
    }, body: {
      'Module': 'Files',
      'Method': 'GetFiles',
      'Parameters': parameters
    });

    final resBody = json.decode(res.body);

    if (resBody['Result'] != null && resBody['Result']['Items'] is List) {
      return _sortFiles(resBody['Result']['Items']);
    } else {
      throw Exception(getErrMsgFromCode(resBody["ErrorCode"]));
    }
  }

  List _sortFiles(List unsortedFiles) {
    final List folders = List();
    final List files = List();

    unsortedFiles.forEach((item) {
      if (item["IsFolder"])
        folders.add(item);
      else
        files.add(item);
    });

    return [...folders, ...files].toList();
  }
}
