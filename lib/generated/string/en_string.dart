import 'dart:ui';

//// ignore_for_file: non_constant_identifier_names
//// ignore_for_file: camel_case_types
//// ignore_for_file: prefer_single_quotes

import 's.dart';

class EnString extends S {
  final Locale locale = Locale("en");
  final String mail = "Mail";
  final String contacts = "Contacts";
  final String files = "Files";
  final String calendar = "Calendar";
  final String tasks = "Tasks";
  final String cancel = "Cancel";
  String quota_using(String progress, limit) =>
      "You are using $progress% of your $limit";
  final String offline_mode = "Offline mode";
  final String settings = "Settings";
  final String log_out = "Log out";
  String no_route(String name) => "No route defined for $name";
  final String common = "Common";
  final String encryption = "Encryption";
  final String openPGP = "OpenPGP";
  final String storage_info = "Storage info";
  final String about = "About";
  String version(String version) => "Version $version";
  final String terms = "Terms of Service";
  final String privacy_policy = "Privacy policy";
  final String clear_cache = "Clear cache";
  final String confirm_delete =
      "Are you sure you want to delete all the cached files and images? This will not affect saved files for offline.";
  final String clear = "Clear";
  final String cache_cleared_success = "Cache cleared successfully";
  final String app_theme = "App theme";
  final String system_theme = "System theme";
  final String dark_theme = "Dark";
  final String light_theme = "Light";
  final String encryption_description =
      "Files are encrypted/decrypted right on this device, even the server itself cannot get access to original content of paranoid-encrypted files. Encryption method is AES256.";
  final String delete_encryption_key_success =
      "The encryption key was successfully deleted.";
  final String delete_key = "Delete key";
  final String share_key = "Share key";
  final String download_key = "Download key";
  final String encryption_export_description =
      "To access encrypted files on other devices/browsers, export the key and then import it on another device/browser.";
  final String encryption_keys = "Encryption key:";
  final String generate_keys = "Generate keys";
  final String key_not_found_in_file = "Could not find a key in this file";
  final String import_encryption_key_success =
      "The encryption key was successfully imported";
  final String import_key_from_file = "Import key from file";
  final String import_key_from_text = "Import key from text";
  final String need_to_set_encryption_key =
      "To start using encryption of uploaded files your need to set an encryption key.";
  final String oK = "OK";
  String key_downloaded_into(String dir) => "The key was downloaded into: $dir";
  final String import_key = "Import key";
  final String generate_key = "Generate key";
  final String add_key_progress = "Adding encryption key...";
  final String key_name = "Key name";
  final String key_text = "Key text";
  final String import = "Import";
  final String generate = "Generate";
  final String delete_key_description =
      "Warning! You'll no longer be able to decrypt encrypted files on this device unless you import this key again.";
  final String delete = "Delete";
  final String download_key_progress = "Downloading the key...";
  final String download_confirm = "Are you sure you want to download this key?";
  final String email = "Email";
  final String password = "Password";
  final String select_length = "Select length";
  final String length = "Length";
  final String close = "Close";
  final String password_is_empty = "password is empty";
  final String already_have_key = "You already have the key(s) for this email";
  final String already_have_keys =
      "Keys which are already in the system are greyed out.";
  final String import_selected_keys = "Import selected keys";
  final String check_keys = "Check keys";
  final String all_public_keys = "All public keys";
  final String send_all = "Send all";
  final String download_all = "Download all";
  String downloading_to(String path) => "Downloading $path";
  final String private_key = "Private key";
  final String public_key = "Public key";
  final String share = "Share";
  final String download = "Download";
  String confirm_delete_pgp_key(String email) =>
      "Are you sure you want to delete OpenPGP key for $email?";
  final String public_keys = "Public keys";
  final String private_keys = "Private keys";
  final String export_all_public_keys = "Export all public keys";
  final String import_keys_from_text = "Import keys from text";
  final String import_keys_from_file = "Import keys from file";
  final String offline_information_is_not_available =
      "This information is not available when you're offline.";
  final String information_is_not_available =
      "This information is not available at the moment.";
  String available_space(String format) => "Available space: $format";
  String used_space(String used, limit) => "Used space: $used out of $limit";
  final String upgrade_now = "Upgrade now";
  final String has_public_link = "Has public link";
  final String available_offline = "Available offline";
  final String synched_successfully = "File synched successfully";
  final String synch_file_progress = "Synching file...";
  String downloaded_successfully_into(String name, path) =>
      "$name downloaded successfully into: $path";
  String downloading(String name) => "Downloading $name";
  final String set_any_encryption_key =
      "You have enabled encryption of uploaded files but haven't set any encryption key.";
  final String need_an_encryption_to_share =
      "You need an encryption key to share files.";
  final String need_an_encryption_to_download =
      "You need an encryption key to download files.";
  final String search = "Search";
  final String add_folder = "Add folder";
  final String move_file_or_folder = "Move files/folders";
  final String copy = "Copy";
  final String move = "Move";
  final String link_coppied_to_clipboard = "Link coppied to clipboard";
  final String public_link_access = "Public link access";
  final String copy_public_link = "Copy public link";
  final String btn_shareable_link = "Create shareable link";
  final String btn_encrypted_shareable_link = "Share encrypted file";
  final String has_PGP_public_key =
      "Selected recipient has PGP public key. The data can be encrypted using this key.";
  final String has_no_PGP_public_key =
      "Selected recipient has no PGP public key. The key based encryption is not allowed.";
  final String encryption_type = "Encryption type:";
  final String key_will_be_used = "The Key based encryption will be used";
  final String password_will_be_used =
      "The Password based encryption will be used";
  final String encrypt = "Encrypt";
  final String key_based = "Key based";
  final String password_based = "Password based";
  final String not_have_recipiens = "No recipients specified";
  final String select_recipient = "Select recipient:";
  final String cant_load_recipients = "Can't load recipients:";
  final String try_again = "Try again";
  final String no_name = "No name";
  String encrypted_using_key(String user) =>
      "The file is encrypted using $user's PGP public key. You can send the link via encrypted email.";
  final String encrypted_using_password =
      "If you don't send email now, store the password somewhere. You will not be able to recover it otherwise.";
  final String add_new_folder = "Add new folder";
  String adding_folder(String name) => "Adding $name folder";
  final String enter_folder_name = "Enter folder name";
  final String add = "Add";
  final String file = "file";
  final String folder = "folder";
  final String delete_files = "Delete files";
  final String delete_file = "Delete file";
  String confirm_delete_file(String file) =>
      "Are you sure you want to delete $file";
  String these_files(String count) => "these $count files/folders ";
  String this_file(String name) => "this $name?";
  final String offline = "Offline";
  final String copy_or_move = "Copy/Move";
  final String rename = "Rename";
  String renaming_to(String name) => "Renaming to $name";
  final String enter_new_name = "Enter new name";
  final String share_file = "Share file";
  final String getting_file_progress = "Getting file for sharing...";
  final String decrypt_error =
      "An error occurred during the decryption process. Perhaps, this file was encrypted with another key.";
  final String file_is_damaged = "Error occured. Perhaps this file is damaged.";
  final String encrypted = "Encrypted";
  final String open_PDF = "Open PDF";
  final String please_wait_until_loading =
      "Please wait until the file finishes loading";
  final String delete_from_offline = "Delete file from offline";
  final String filename = "Filename";
  final String size = "Size";
  final String created = "Created";
  final String location = "Location";
  final String owner = "Owner";
  final String need_an_encryption_to_uploading =
      "You need to set an encryption key before uploading files.";
  final String successfully_uploaded = "File successfully uploaded";
  final String no_internet_connection = "No internet connection";
  final String retry = "Retry";
  final String go_offline = "Go offline";
  final String no_results = "No results";
  final String empty_here = "Empty here";
  final String upgrade_your_plan =
      "Mobile apps are not allowed in your billing plan.";
  final String please_upgrade_your_plan =
      "Mobile apps are not allowed in your billing plan.\nPlease upgrade your plan.";
  final String back_to_login = "Back to login";
  final String please_enter_hostname = "Please enter hostname";
  final String please_enter_email = "Please enter email";
  final String please_enter_password = "Please enter password";
  final String enter_host =
      "Could not detect domain from this email, please specify your server URL manually.";
  final String host = "Host";
  final String login = "Login";
  final String encrypted_file_link = "Encrypted file public link:";
  final String send = "Send via email";
  final String send_encrypted = "Send via encrypted email";
  final String upload = "Upload";
  final String encrypt_error = "Encrypt error";
  final String encrypted_file_password = "Encrypted file password";
  final String create_link = "Create shareable link";
  final String create_encrypt_link = "Create protected public link";
  final String encrypt_link = "Protect public link with password";
  final String public_link = "Public link";
  final String remove_link = "Remove link";
  final String send_to = "Send to..";
  final String recipient = "Recipient";
  final String encrypted_mail_using_key =
      "You can send the link and the password via email.";
  final String send_email = "You can send the link via email.";
  final String sending = "Sending..";
  final String sending_complete = "Sending complete";
  final String failed = "Failed";
  final String keys_not_found = "Keys not found";
  String sign_with_not_key(String data) =>
      "$data can't be signed because the private key has not been added.";
  final String invalid_password = "Invalid password";
  final String sign_email = "Add digital signature";
  final String sign_file_email = "Sign the file and email";
  final String data = "data";
  String sign_data_with_not_key(String data) =>
      "Will not sign the $data because you don’t have PGP private key.";
  String sign_mail_with_not_key(String data) =>
      "The $data will not be signed because you don’t have PGP private key.";
  final String password_sign =
      "For password-based encryption the PGP-signing is not supported.";
  final String email_signed =
      "The email will be signed using your private key.";
  final String data_signed = "Will sign the data with your private key.";
  String data_not_signed(String data) => "The $data will not be signed.";
  final String protected_public_link = "Protected public link";
  final String send_public_link_to = "Send public link to";
  final String copy_password =
      "You can send the link via email. The password must be sent using a different channel.\n\nYou will be able to retrieve the password when needed.";
  final String copy_encrypted_password =
      "You can send the link via email. The password must be sent using a different channel.\n\n  Store the password somewhere. You will not be able to recover it otherwise.";
  String encrypted_sign_using_key(String user) =>
      "The file is encrypted using $user's PGP public key. You can send the link via digitally signed encrypted email.";
  final String email_not_signed = "The email will not be signed.";
  final String two_factor_auth =
      "Your account is protected with\nTwo Factor Authentication.\nPlease provide the PIN code.";
  final String pin = "PIN";
  final String verify_pin = "Verify pin";
  final String invalid_pin = "Invalid PIN";
  final String upload_file = "Upload file";
  String upload_files(String count) => "Upload $count files";
  final String login_to_continue = "Log in to continue";
  final String confirm_exit = "Are you sure want to exit?";
  final String exit = "Exit";
  final String error_required_pgp_key = "Required PGP key";
  final String label_required_pgp_key = "Required PGP key";
  String hint_upload_encrypt_ask(String name) => "Encrypt '$name'?.";
  final String btn_do_not_encrypt = "Do not encrypt";
  final String label_encryption_always_in_encryption_folder =
      "Always in Encrypted folder";
  final String label_encryption_always = "Always";
  final String label_encryption_ask = "Ask me";
  final String label_encryption_never = "Never";
  final String label_encryption_enable_paranoid_encryption =
      "Enable Paranoid Encryption";
  final String btn_encryption_enable = "Enable Paranoid Encryption";
  final String label_encryption_mode = "Encrypt uploaded files";
  final String btn_encryption_save = "Save";
  final String label_encryption_password_for_pgp_key =
      "Required password for PGP key";
  final String btn_share_save = "Save";
  final String label_pgp_import_key = "Import keys";
  final String hint_pgp_already_have_keys =
      "Keys which are already in the system are greyed out.";
  final String hint_pgp_your_keys = "Your keys";
  final String hint_pgp_keys_will_be_import_to_contacts =
      "The keys will be imported to contacts";
  final String btn_pgp_import_selected_key = "Import selected keys";
  final String label_pgp_contact_public_keys = "External public keys";
  String error_pgp_required_key(String user) => "Required PGP key for $user";
  final String btn_share_to_email = "Share with teammates";
  final String hint_pgp_share_warning =
      "You are going to share you private PGP key. The key must be kept from the 3rd parties. Do you want to continue?";
  final String label_pgp_share_warning = "Warning";
  final String hint_share_folder =
      "Encrypted files will not be available in shared folder.";
  final String input_who_cas_see = "Who can see";
  final String input_who_cas_edit = "Who can edit";
  final String btn_show_encrypt = "Show";
  final String label_store_password_in_session =
      "Store OpenPGP key password within a session";
  final String btn_enable_backward_compatibility =
      "Enable backward compatibility";
  final String error_backward_compatibility_sharing_not_supported =
      "The sharing of this file is not supported. The file is encrypted using the old encryption mode. The file must be uploaded and encrypted using the modern encryption mode. Please download and upload the file again.";
  final String hint_backward_compatibility_aes_key =
      "The AES key will be used only to decrypt the files that are encrypted using the old encryption mode. The new files will be encrypted using modern encryption mode.";
  final String label_delete_folder = "Delete folder";
  final String fido_error_invalid_key = "Invalid security key";
  final String tfa_label = "Two Factor Verification";
  final String tfa_hint_step =
      "This extra step is intended to confirm it’s really you trying to sign in";
  final String fido_btn_use_key = "Use security key";
  final String fido_label_connect_your_key =
      "Please scan your security key or insert it to the device";
  final String fido_label_success = "Success";
  final String tfa_btn_other_options = "Other options";
  final String tfa_btn_use_backup_code = "Use Backup code";
  final String tfa_btn_use_auth_app = "Use Authenticator app";
  final String tfa_btn_use_security_key = "Use your Security key";
  final String tfa_label_hint_security_options = "Security options available";
  final String fido_label_touch_your_key = "Touch you security key";
  final String fido_hint_follow_the_instructions =
      "Please follow the instructions in the popup dialog";
  final String fido_error_title = "There was a problem";
  final String fido_error_hint =
      "Try using your security key again or try another way to verify it's you";
  final String fido_btn_try_again = "Try again";
  final String tfa_input_hint_code_from_app =
      "Specify verification code from the Authenticator app";
  final String btn_login_back_to_login = "Back to login";
  final String input_2fa_pin = "Verification code";
  final String btn_verify_pin = "Verify";
  final String error_invalid_pin = "Invalid code";
  final String tfa_label_enter_backup_code =
      "Enter one of your 8-character backup codes";
  final String tfa_input_backup_code = "Backup code";
  final String tfa_label_trust_device = "You're all set";
  String tfa_check_box_trust_device(String daysCount) =>
      "Don't ask again on this device for $daysCount days";
  final String tfa_button_continue = "Continue";
  final String logger_label_show_debug_view = "Show debug view";
  final String logger_btn_delete_all = "Delete all";
  final String logger_hint_delete_all_logs =
      "Are you sure you want to delete all logs";
  final String logger_hint_delete_log =
      "Are you sure you want to delete the file";
  final String clear_cache_during_logout = "Delete cached data and keys";
}
