import 'package:aurorafiles/models/files_type.dart';
import 'package:aurorafiles/screens/files/files_repository.dart';
import 'package:mobx/mobx.dart';

part 'files_state.g.dart';

class FilesState = _FilesState with _$FilesState;

abstract class _FilesState with Store {
  final _repo = FilesRepository();

  final filesTileLeadingSize = 48.0;

  @observable
  List<dynamic> currentFiles;

  @observable
  Set<String> selectedFilesIds = new Set();

  @observable
  String currentPath = "";

  @observable
  String currentFilesType = FilesType.personal;

  @observable
  bool isFilesLoading = false;

  @action
  void setCurrentFilesType(String filesType) => currentFilesType = filesType;

  @action
  void onSelectFile(String id) {
    // reassigning to update the observable
    final selectedIds = selectedFilesIds;
    if (selectedFilesIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedFilesIds = selectedIds;
  }

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
