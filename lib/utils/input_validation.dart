enum ValidationTypes {
  empty,
  email,
  folderSlash,
  uniqueName,
}

String validateInput(
  String value,
  List<ValidationTypes> types, [
  List files,
  String fileExtension,
]) {
  if (types.contains(ValidationTypes.uniqueName) && files is! List) {
    throw Exception(
        "In order to check if a name is unique the list must be provided");
  }
  if (types.contains(ValidationTypes.empty) && value.isEmpty) {
    return "This field is required";
  }
  if (types.contains(ValidationTypes.email) && !_isEmailValid(value)) {
    return "The email is not valid";
  }
  if (types.contains(ValidationTypes.folderSlash) && value.contains("/")) {
    return "Folder name cannot contain '/'";
  }
  if (files is List && types.contains(ValidationTypes.uniqueName)) {
    bool exists = false;
    final valueToCheck = fileExtension != null ? "$value.$fileExtension" : value;
    files.forEach((file) {
      if (file["Name"] == valueToCheck) exists = true;
    });

    if (exists) return "This name already exists";
  }

  // else the field is valid
  return null;
}

bool _isEmailValid(String email) {
  final regExp = new RegExp(
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return regExp.hasMatch(email);
}
