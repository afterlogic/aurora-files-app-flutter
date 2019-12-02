import 'package:flutter/services.dart';

class PlatformCall {
  static hideTextInput() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}
