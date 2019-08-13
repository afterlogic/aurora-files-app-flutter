import 'package:aurorafiles/screens/file_viewer/file_viewer_repository.dart';
import 'package:mobx/mobx.dart';

part 'file_viewer_state.g.dart';

class FileViewerState = _FileViewerState with _$FileViewerState;

abstract class _FileViewerState with Store {
  final _repo = FileViewerRepository();

  void onDownloadFile({
    String url,
    String fileName,
    Function onStart,
    Function onSuccess,
    Function onError,
  }) async {
    try {
      onStart();
      await _repo.downloadFile(url, fileName);
      _repo.getDownloadStatus(onSuccess);
    } catch (err) {
      onError(err);
    }
  }
}
