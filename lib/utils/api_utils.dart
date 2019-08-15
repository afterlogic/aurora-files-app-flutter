Map<String, String> getHeader(String authToken) {
  return {'Authorization': 'Bearer $authToken'};
}

String getErrMsg(dynamic err) {
  if (err["ErrorMessage"] is String) {
    return err["ErrorMessage"];
  } else if (err["ErrorCode"] is int) {
    return _getErrMsgFromCode(err["ErrorCode"]);
  } else {
    return "Unknown error";
  }
}

String _getErrMsgFromCode(int code) {
  switch (code) {
    case (102):
      return "Invalid email/password";
    default:
      return code.toString();
  }
}