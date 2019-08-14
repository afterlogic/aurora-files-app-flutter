import 'package:aurorafiles/models/files_type.dart';
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
  String currentFilesType = FilesType.personal;

  @observable
  bool isFilesLoading = false;

  @action
  void setCurrentFilesType(String filesType) => currentFilesType = filesType;

  @action
  Future<void> onGetFiles({String path = ""}) async {
    currentPath = path;
    try {
      isFilesLoading = true;
      currentFiles = await _repo.getFiles(currentFilesType, currentPath, "");
    } catch (err) {
      print("VO: err, $err");
    } finally {
      isFilesLoading = false;
    }
  }

  @action
  void onLevelUp() {
    final List<String> pathArray = currentPath.split("/");
    pathArray.removeLast();
    currentPath = pathArray.join("/");
    onGetFiles(path: currentPath);
  }
}
