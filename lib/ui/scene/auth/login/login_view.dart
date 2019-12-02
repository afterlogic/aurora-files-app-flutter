import 'package:domain/api/network/error/network_error.dart';
import 'package:mpv/mpv.dart';
import 'package:rxdart/rxdart.dart';

mixin LoginView implements View {
  final progress = BehaviorSubject<bool>();

  setEmail(String email);

  showHost();

  showError(Object errorCase,[String message]);

  @override
  close() {
    progress.close();
  }
}
