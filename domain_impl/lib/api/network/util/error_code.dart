class ErrorCode {
  static const invalidToken = 101;
  static const invalidEmailPassword = 102;
  static const invalidInputParameter = 103;
  static const dataBaseError = 104;
  static const licenseProblem = 105;
  static const demoAccount = 106;
  static const captchaError = 107;
  static const accessDenied = 108;
  static const unknownEmail = 109;
  static const userisNotAllowed = 110;
  static const suchUserAlreadyExists = 111;
  static const systemIsNotConfigured = 112;
  static const moduleNotFound = 113;
  static const methodNotFound = 114;
  static const licenseLimit = 115;
  static const cannotSaveSettings = 501;
  static const cannotChangePassword = 502;
  static const accountOldPasswordIsNotCorrect = 503;
  static const cannotCreateContact = 601;
  static const cannotCreateGroup = 602;
  static const cannotUpdateContact = 603;
  static const cannotUpdateGroup = 604;
  static const dataHasBeenModified = 605;
  static const cannotGetContact = 607;
  static const cannotCreateAccount = 701;
  static const suchAccountAlreadyExists = 704;
  static const restOtherError = 710;
  static const restApiDisabled = 711;
  static const restUnknownMethod = 712;
  static const restInvalidParameters = 713;
  static const restInvalidCredentials = 714;
  static const restInvalidToken = 715;
  static const restTokenExpired = 716;
  static const restAccountFindFailed = 717;
  static const restTenantFindFailed = 719;
  static const calendarsNotAllowed = 801;
  static const filesNotAllowed = 802;
  static const contactsNotAllowed = 803;
  static const helpdeskUserAlreadyExists = 804;
  static const helpdeskSystemUserAlreadyExists = 805;
  static const cannotCreateJHelpdeskUser = 806;
  static const helpdeskUnknownUser = 807;
  static const helpdeskUnactivatedUser = 808;
  static const voiceNotAllowed = 810;
  static const incorrectFileExtension = 811;
  static const spaceLimit = 812;
  static const fileAlreadyExists = 813;
  static const fileNotFound = 814;
  static const cannotUploadFileLimit = 815;
  static const mailServerError = 901;
  static const unknownError = 999;

  String message(int code) {
    switch (code) {
      case invalidToken:
        return "Invalid token";
      case invalidEmailPassword:
        return "Invalid email/password";
      case invalidInputParameter:
        return "Invalid input parameter";
      case dataBaseError:
        return "DataBase error";
      case licenseProblem:
        return "License problem";
      case demoAccount:
        return "Demo account";
      case captchaError:
        return "Captcha error";
      case accessDenied:
        return "Access denied";
      case unknownError:
        return "Unknown email";
      case userisNotAllowed:
        return "User is not allowed";
      case suchUserAlreadyExists:
        return "Such user already exists";
      case systemIsNotConfigured:
        return "System is not configured";
      case moduleNotFound:
        return "Module not found";
      case methodNotFound:
        return "Method not found";
      case licenseLimit:
        return "License limit";
      case cannotSaveSettings:
        return "Cannot save settings";
      case cannotChangePassword:
        return "Cannot change password";
      case accountOldPasswordIsNotCorrect:
        return "Account's old password is not correct";
      case cannotCreateContact:
        return "Cannot create contact";
      case cannotCreateGroup:
        return "Cannot create group";
      case cannotUpdateContact:
        return "Cannot update contact";
      case cannotUpdateGroup:
        return "Cannot update group";
      case dataHasBeenModified:
        return "Contact data has been modified by another application";
      case cannotGetContact:
        return "Cannot get contact";
      case cannotCreateAccount:
        return "Cannot create account";
      case suchAccountAlreadyExists:
        return "Such account already exists";
      case restOtherError:
        return "Rest other error";
      case restApiDisabled:
        return "Rest api disabled";
      case restUnknownMethod:
        return "Rest unknown method";
      case restInvalidParameters:
        return "Rest invalid parameters";
      case restInvalidCredentials:
        return "Rest invalid credentials";
      case restInvalidToken:
        return "Rest invalid token";
      case restTokenExpired:
        return "Rest token expired";
      case restAccountFindFailed:
        return "Rest account find failed";
      case restTenantFindFailed:
        return "Rest tenant find failed";
      case calendarsNotAllowed:
        return "Calendars not allowed";
      case filesNotAllowed:
        return "Files not allowed";
      case contactsNotAllowed:
        return "Contacts not allowed";
      case helpdeskUserAlreadyExists:
        return "Helpdesk user already exists";
      case helpdeskSystemUserAlreadyExists:
        return "Helpdesk system user already exists";
      case cannotCreateJHelpdeskUser:
        return "Cannot create helpdesk user";
      case helpdeskUnknownUser:
        return "Helpdesk unknown user";
      case helpdeskUnactivatedUser:
        return "Helpdesk unactivated user";
      case voiceNotAllowed:
        return "Voice not allowed";
      case incorrectFileExtension:
        return "Incorrect file extension";
      case spaceLimit:
        return "You have reached your cloud storage space limit. Can't upload file.";
      case fileAlreadyExists:
        return "Such file already exists";
      case fileNotFound:
        return "File not found";
      case cannotUploadFileLimit:
        return "Cannot upload file limit";
      case mailServerError:
        return "Mail server error";
      case unknownError:
        return "Unknown error";
      default:
        return code.toString();
    }
  }
}
