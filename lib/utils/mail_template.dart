class MailTemplate {
  final String subject;
  String body;

  MailTemplate(this.subject, this.body);

  static MailTemplate getTemplate(
    bool encryptedFile,
    bool useKey,
    String file,
    String link,
    String password,
    String recipient,
    String sender,
  ) {
    return MailTemplate(
      _getSubject(file, encryptedFile),
      _getBody(encryptedFile, useKey, link, password, recipient, sender),
    );
  }

  static _getSubject(String file, bool encryptedFile) {
    return encryptedFile
        ? "The encrypted file was shared with you: \"$file\""
        : "The file was shared with you: \"$file\"";
  }

  static _getBody(
    bool encryptedFile,
    bool useKey,
    String link,
    String password,
    String recipient,
    String sender,
  ) {
    var body = "";

    body += encryptedFile ? "Hi" : "Hello,";
    body += "\n\n";
    body += encryptedFile
        ? "You can get the encrypted file here:  $link"
        : "You can download the file at: $link";
    body += "\n";
    body += useKey
        ? "\nThe file is encrypted using $recipient's PGP public key.You can decrypt it if you're logged in PrivateMail WebMail Client system. If you're not logged in there, you'll be able to download the encrypted file only. You can decrypt it using other PGP tools then."
        : password?.isNotEmpty == true
            ? encryptedFile
                ? "File encrypted with password: $password"
                : "Link secure with password: $password"
            : "";
    body += "\n\n";
    body += "Regards\n"
        "$sender";

    return body;
  }
}
