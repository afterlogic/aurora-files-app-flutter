import 'package:aurorafiles/screens/files/files_repository.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

abstract class _FilesState with Store {
  final _repo = FilesRepository();

  @observable
  List<dynamic> currentFiles;

  @observable
  String currentPath = "";

  @observable
  bool isFilesLoading = false;

  @action
  Future<void> onGetFiles({String path = ""}) async {
    currentPath = path;
    try {
      isFilesLoading = true;
      currentFiles = await _repo.getFiles("personal", currentPath, "");
    } catch (err) {
      print("VO: err, $err");
    } finally {
      isFilesLoading = false;
    }
  }

  @action
  void onLevelUp () {
    final List<String> pathArray = currentPath.split("/");
    pathArray.removeLast();
    currentPath = pathArray.join("/");
    onGetFiles(path: currentPath);
  }
}
