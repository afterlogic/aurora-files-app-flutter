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
    final valueToCheck =
        fileExtension != null ? "$value.$fileExtension" : value;
    otherItems.forEach((item) {
      if (item is LocalFile) {
        if (item.name == valueToCheck) exists = true;
      }
    });

    if (exists) return "This name already exists";
  }

  // else the field is valid
  return null;
}

bool _isFileNameValid(String fileName) {
  final regExp = new RegExp(r'["\/\\*?<>|:]');

  return !regExp.hasMatch(fileName);
}

bool isEmailValid(String email) {
  final regExp = new RegExp(
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return regExp.hasMatch(email);
}
