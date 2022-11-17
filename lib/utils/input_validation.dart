import 'package:aurorafiles/database/app_database.dart';

enum ValidationTypes {
  empty,
  email,
  fileName,
  uniqueName,
}

String? validateInput(
  String value,
  List<ValidationTypes> types, [
  List<dynamic>? otherItems,
  String? fileExtension,
  String? filePath,
]) {
  if (types.contains(ValidationTypes.uniqueName) && otherItems == null) {
    throw Exception(
        "In order to check if a name is unique the list must be provided");
  }
  if (types.contains(ValidationTypes.empty) && value.isEmpty) {
    return "This field is required";
  }
  if (types.contains(ValidationTypes.email) && !isEmailValid(value)) {
    return "The email is not valid";
  }
  if (types.contains(ValidationTypes.fileName) && !_isFileNameValid(value)) {
    return 'Name cannot contain "/\\*?<>|:';
  }
  if (otherItems != null && types.contains(ValidationTypes.uniqueName)) {
    bool exists = false;
    for (var i = 0; i < otherItems.length; i++) {
      final item = otherItems[i];
      if (item is LocalFile) {
        String valueToCheck = value;
        if (filePath != null) {
          valueToCheck = filePath + valueToCheck;
        }
        if (fileExtension != null) {
          valueToCheck = valueToCheck + '.' + fileExtension;
        }
        final checkedName =
            filePath == null ? item.name : item.path + item.name;
        if (checkedName == valueToCheck) {
          exists = true;
          break;
        }
      }
    }

    if (exists) return "This name already exists";
  }

  // else the field is valid
  return null;
}

bool _isFileNameValid(String fileName) {
  final regExp = RegExp(r'["\/\\*?<>|:]');

  return !regExp.hasMatch(fileName);
}

bool isEmailValid(String email) {
  final regExp = RegExp(
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return regExp.hasMatch(email);
}
