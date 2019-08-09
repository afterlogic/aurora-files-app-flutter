String getErrMsgFromCode(int code) {
  switch (code) {
    case (102):
      return "Invalid email/password";
    default:
      return code.toString();
  }
}