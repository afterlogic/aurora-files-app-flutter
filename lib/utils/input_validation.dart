enum ValidationTypes {
  empty,
  email,
}

String validateInput(String value, List<ValidationTypes> types) {
  if (types.contains(ValidationTypes.empty) && value.isEmpty) {
    return "This field is required";
  }
  if (types.contains(ValidationTypes.email) && !_isEmailValid(value)) {
    return "The email is not valid";
  }

  // else the field is valid
  return null;
}

bool _isEmailValid(String email) {
  final regExp = new RegExp(
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  return regExp.hasMatch(email);
}
