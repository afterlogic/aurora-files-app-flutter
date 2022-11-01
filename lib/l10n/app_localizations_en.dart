//ignore_for_file: non_constant_identifier_names

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get mail => 'Mail';

  @override
  String get contacts => 'Contacts';

  @override
  String get files => 'Files';

  @override
  String get calendar => 'Calendar';

  @override
  String get tasks => 'Tasks';

  @override
  String get cancel => 'Cancel';

  @override
  String quota_using(String progress, String limit) {
    return 'You are using $progress% of your $limit';
  }

  @override
  String get offline_mode => 'Offline mode';

  @override
  String get settings => 'Settings';

  @override
  String get log_out => 'Log out';

  @override
  String no_route(String name) {
    return 'No route defined for $name';
  }

  @override
  String get common => 'Common';

  @override
  String get encryption => 'Encryption';

  @override
  String get openPGP => 'OpenPGP';

  @override
  String get storage_info => 'Storage info';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get terms => 'Terms of Service';

  @override
  String get privacy_policy => 'Privacy policy';

  @override
  String get clear_cache => 'Clear cache';

  @override
  String get confirm_delete => 'Are you sure you want to delete all the cached files and images? This will not affect saved files for offline.';

  @override
  String get clear => 'Clear';

  @override
  String get cache_cleared_success => 'Cache cleared successfully';

  @override
  String get app_theme => 'App theme';

  @override
  String get system_theme => 'System theme';

  @override
  String get dark_theme => 'Dark';

  @override
  String get light_theme => 'Light';

  @override
  String get encryption_description => 'Files are encrypted/decrypted right on this device, even the server itself cannot get access to original content of paranoid-encrypted files. Encryption method is AES256.';

  @override
  String get delete_encryption_key_success => 'The encryption key was successfully deleted.';

  @override
  String get delete_key => 'Delete key';

  @override
  String get share_key => 'Share key';

  @override
  String get download_key => 'Download key';

  @override
  String get encryption_export_description => 'To access encrypted files on other devices/browsers, export the key and then import it on another device/browser.';

  @override
  String get encryption_keys => 'Encryption key:';

  @override
  String get generate_keys => 'Generate keys';

  @override
  String get key_not_found_in_file => 'Could not find a key in this file';

  @override
  String get import_encryption_key_success => 'The encryption key was successfully imported';

  @override
  String get import_key_from_file => 'Import key from file';

  @override
  String get import_key_from_text => 'Import key from text';

  @override
  String get need_to_set_encryption_key => 'To start using encryption of uploaded files your need to set an encryption key.';

  @override
  String get oK => 'OK';

  @override
  String key_downloaded_into(String dir) {
    return 'The key was downloaded into: $dir';
  }

  @override
  String get import_key => 'Import key';

  @override
  String get generate_key => 'Generate key';

  @override
  String get add_key_progress => 'Adding encryption key...';

  @override
  String get key_name => 'Key name';

  @override
  String get key_text => 'Key text';

  @override
  String get import => 'Import';

  @override
  String get generate => 'Generate';

  @override
  String get delete_key_description => 'Warning! You\'ll no longer be able to decrypt encrypted files on this device unless you import this key again.';

  @override
  String get delete => 'Delete';

  @override
  String get download_key_progress => 'Downloading the key...';

  @override
  String get download_confirm => 'Are you sure you want to download this key?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get select_length => 'Select length';

  @override
  String get length => 'Length';

  @override
  String get close => 'Close';

  @override
  String get password_is_empty => 'password is empty';

  @override
  String get already_have_key => 'You already have the key(s) for this email';

  @override
  String get already_have_keys => 'Keys which are already in the system are greyed out.';

  @override
  String get import_selected_keys => 'Import selected keys';

  @override
  String get check_keys => 'Check keys';

  @override
  String get all_public_keys => 'All public keys';

  @override
  String get send_all => 'Send all';

  @override
  String get download_all => 'Download all';

  @override
  String downloading_to(String path) {
    return 'Downloading $path';
  }

  @override
  String get private_key => 'Private key';

  @override
  String get public_key => 'Public key';

  @override
  String get share => 'Share';

  @override
  String get download => 'Download';

  @override
  String confirm_delete_pgp_key(String email) {
    return 'Are you sure you want to delete OpenPGP key for $email?';
  }

  @override
  String get public_keys => 'Public keys';

  @override
  String get private_keys => 'Private keys';

  @override
  String get export_all_public_keys => 'Export all public keys';

  @override
  String get import_keys_from_text => 'Import keys from text';

  @override
  String get import_keys_from_file => 'Import keys from file';

  @override
  String get offline_information_is_not_available => 'This information is not available when you\'re offline.';

  @override
  String get information_is_not_available => 'This information is not available at the moment.';

  @override
  String available_space(String format) {
    return 'Available space: $format';
  }

  @override
  String used_space(String used, String limit) {
    return 'Used space: $used out of $limit';
  }

  @override
  String get upgrade_now => 'Upgrade now';

  @override
  String get has_public_link => 'Has public link';

  @override
  String get available_offline => 'Available offline';

  @override
  String get synched_successfully => 'File synched successfully';

  @override
  String get synch_file_progress => 'Synching file...';

  @override
  String downloaded_successfully_into(String name, String path) {
    return '$name downloaded successfully into: $path';
  }

  @override
  String downloading(String name) {
    return 'Downloading $name';
  }

  @override
  String get set_any_encryption_key => 'You have enabled encryption of uploaded files but haven\'t set any encryption key.';

  @override
  String get need_an_encryption_to_share => 'You need an encryption key to share files.';

  @override
  String get need_an_encryption_to_download => 'You need an encryption key to download files.';

  @override
  String get search => 'Search';

  @override
  String get add_folder => 'Add folder';

  @override
  String get move_file_or_folder => 'Move files/folders';

  @override
  String get copy => 'Copy';

  @override
  String get move => 'Move';

  @override
  String get link_coppied_to_clipboard => 'Link coppied to clipboard';

  @override
  String get public_link_access => 'Public link access';

  @override
  String get copy_public_link => 'Copy public link';

  @override
  String get btn_shareable_link => 'Create shareable link';

  @override
  String get btn_encrypted_shareable_link => 'Share encrypted file';

  @override
  String get has_PGP_public_key => 'Selected recipient has PGP public key. The data can be encrypted using this key.';

  @override
  String get has_no_PGP_public_key => 'Selected recipient has no PGP public key. The key based encryption is not allowed.';

  @override
  String get encryption_type => 'Encryption type:';

  @override
  String get key_will_be_used => 'The Key based encryption will be used';

  @override
  String get password_will_be_used => 'The Password based encryption will be used';

  @override
  String get encrypt => 'Encrypt';

  @override
  String get key_based => 'Key based';

  @override
  String get password_based => 'Password based';

  @override
  String get not_have_recipiens => 'No recipients specified';

  @override
  String get select_recipient => 'Select recipient:';

  @override
  String get cant_load_recipients => 'Can\'t load recipients:';

  @override
  String get try_again => 'Try again';

  @override
  String get no_name => 'No name';

  @override
  String encrypted_using_key(String user) {
    return 'The file is encrypted using $user\'s PGP public key. You can send the link via encrypted email.';
  }

  @override
  String get encrypted_using_password => 'If you don\'t send email now, store the password somewhere. You will not be able to recover it otherwise.';

  @override
  String get add_new_folder => 'Add new folder';

  @override
  String adding_folder(String name) {
    return 'Adding $name folder';
  }

  @override
  String get enter_folder_name => 'Enter folder name';

  @override
  String get add => 'Add';

  @override
  String get file => 'file';

  @override
  String get folder => 'folder';

  @override
  String get delete_files => 'Delete files';

  @override
  String get delete_file => 'Delete file';

  @override
  String confirm_delete_file(String file) {
    return 'Are you sure you want to delete $file';
  }

  @override
  String these_files(String count) {
    return 'these $count files/folders ';
  }

  @override
  String this_file(String name) {
    return 'this $name?';
  }

  @override
  String get offline => 'Offline';

  @override
  String get copy_or_move => 'Copy/Move';

  @override
  String get rename => 'Rename';

  @override
  String renaming_to(String name) {
    return 'Renaming to $name';
  }

  @override
  String get enter_new_name => 'Enter new name';

  @override
  String get share_file => 'Share file';

  @override
  String get getting_file_progress => 'Getting file for sharing...';

  @override
  String get decrypt_error => 'An error occurred during the decryption process. Perhaps, this file was encrypted with another key.';

  @override
  String get file_is_damaged => 'Error occured. Perhaps this file is damaged.';

  @override
  String get encrypted => 'Encrypted';

  @override
  String get open_PDF => 'Open PDF';

  @override
  String get please_wait_until_loading => 'Please wait until the file finishes loading';

  @override
  String get delete_from_offline => 'Delete file from offline';

  @override
  String get filename => 'Filename';

  @override
  String get size => 'Size';

  @override
  String get created => 'Created';

  @override
  String get location => 'Location';

  @override
  String get owner => 'Owner';

  @override
  String get need_an_encryption_to_uploading => 'You need to set an encryption key before uploading files.';

  @override
  String get successfully_uploaded => 'File successfully uploaded';

  @override
  String get no_internet_connection => 'No internet connection';

  @override
  String get retry => 'Retry';

  @override
  String get go_offline => 'Go offline';

  @override
  String get no_results => 'No results';

  @override
  String get empty_here => 'Empty here';

  @override
  String get upgrade_your_plan => 'Mobile apps are not allowed in your billing plan.';

  @override
  String get please_upgrade_your_plan => 'Mobile apps are not allowed in your billing plan.\nPlease upgrade your plan.';

  @override
  String get back_to_login => 'Back to login';

  @override
  String get please_enter_hostname => 'Please enter hostname';

  @override
  String get please_enter_email => 'Please enter email';

  @override
  String get please_enter_password => 'Please enter password';

  @override
  String get enter_host => 'Could not detect domain from this email, please specify your server URL manually.';

  @override
  String get host => 'Host';

  @override
  String get login => 'Login';

  @override
  String get encrypted_file_link => 'Encrypted file public link:';

  @override
  String get send => 'Send via email';

  @override
  String get send_encrypted => 'Send via encrypted email';

  @override
  String get upload => 'Upload';

  @override
  String get encrypt_error => 'Encrypt error';

  @override
  String get encrypted_file_password => 'Encrypted file password';

  @override
  String get create_link => 'Create shareable link';

  @override
  String get create_encrypt_link => 'Create protected public link';

  @override
  String get encrypt_link => 'Protect public link with password';

  @override
  String get public_link => 'Public link';

  @override
  String get remove_link => 'Remove link';

  @override
  String get send_to => 'Send to..';

  @override
  String get recipient => 'Recipient';

  @override
  String get encrypted_mail_using_key => 'You can send the link and the password via email.';

  @override
  String get send_email => 'You can send the link via email.';

  @override
  String get sending => 'Sending..';

  @override
  String get sending_complete => 'Sending complete';

  @override
  String get failed => 'Failed';

  @override
  String get keys_not_found => 'Keys not found';

  @override
  String sign_with_not_key(String data) {
    return '$data can\'t be signed because the private key has not been added.';
  }

  @override
  String get invalid_password => 'Invalid password';

  @override
  String get sign_email => 'Add digital signature';

  @override
  String get sign_file_email => 'Sign the file and email';

  @override
  String get data => 'data';

  @override
  String sign_data_with_not_key(String data) {
    return 'Will not sign the $data because you don’t have PGP private key.';
  }

  @override
  String sign_mail_with_not_key(String data) {
    return 'The $data will not be signed because you don’t have PGP private key.';
  }

  @override
  String get password_sign => 'For password-based encryption the PGP-signing is not supported.';

  @override
  String get email_signed => 'The email will be signed using your private key.';

  @override
  String get data_signed => 'Will sign the data with your private key.';

  @override
  String data_not_signed(String data) {
    return 'The $data will not be signed.';
  }

  @override
  String get protected_public_link => 'Protected public link';

  @override
  String get send_public_link_to => 'Send public link to';

  @override
  String get copy_password => 'You can send the link via email. The password must be sent using a different channel.\n\nYou will be able to retrieve the password when needed.';

  @override
  String get copy_encrypted_password => 'You can send the link via email. The password must be sent using a different channel.\n\n  Store the password somewhere. You will not be able to recover it otherwise.';

  @override
  String encrypted_sign_using_key(String user) {
    return 'The file is encrypted using $user\'s PGP public key. You can send the link via digitally signed encrypted email.';
  }

  @override
  String get email_not_signed => 'The email will not be signed.';

  @override
  String get two_factor_auth => 'Your account is protected with\nTwo Factor Authentication.\nPlease provide the PIN code.';

  @override
  String get pin => 'PIN';

  @override
  String get verify_pin => 'Verify pin';

  @override
  String get invalid_pin => 'Invalid PIN';

  @override
  String get upload_file => 'Upload file';

  @override
  String upload_files(String count) {
    return 'Upload $count files';
  }

  @override
  String get login_to_continue => 'Log in to continue';

  @override
  String get confirm_exit => 'Are you sure want to exit?';

  @override
  String get exit => 'Exit';

  @override
  String get error_required_pgp_key => 'Required PGP key';

  @override
  String get label_required_pgp_key => 'Required PGP key';

  @override
  String hint_upload_encrypt_ask(String name) {
    return 'Encrypt \'$name\'?';
  }

  @override
  String get btn_do_not_encrypt => 'Do not encrypt';

  @override
  String get label_encryption_always_in_encryption_folder => 'Always in Encrypted folder';

  @override
  String get label_encryption_always => 'Always';

  @override
  String get label_encryption_ask => 'Ask me';

  @override
  String get label_encryption_never => 'Never';

  @override
  String get label_encryption_enable_paranoid_encryption => 'Enable Paranoid Encryption';

  @override
  String get btn_encryption_enable => 'Enable Paranoid Encryption';

  @override
  String get label_encryption_mode => 'Encrypt uploaded files';

  @override
  String get label_save => 'Save';

  @override
  String get label_encryption_password_for_pgp_key => 'Required password for PGP key';

  @override
  String get label_pgp_import_key => 'Import keys';

  @override
  String get hint_pgp_already_have_keys => 'Keys which are already in the system are greyed out.';

  @override
  String get hint_pgp_your_keys => 'Your keys';

  @override
  String get hint_pgp_keys_will_be_import_to_contacts => 'The keys will be imported to contacts';

  @override
  String get btn_pgp_import_selected_key => 'Import selected keys';

  @override
  String get label_pgp_contact_public_keys => 'External public keys';

  @override
  String error_pgp_required_key(String user) {
    return 'No private key found for $user user.';
  }

  @override
  String get label_share_with_teammates => 'Share with teammates';

  @override
  String get hint_pgp_share_warning => 'You are going to share you private PGP key. The key must be kept from the 3rd parties. Do you want to continue?';

  @override
  String get label_pgp_share_warning => 'Warning';

  @override
  String get hint_share_folder => 'Encrypted files will not be available in shared folder.';

  @override
  String get input_who_cas_see => 'Who can see';

  @override
  String get input_who_cas_edit => 'Who can edit';

  @override
  String get btn_show_encrypt => 'Show';

  @override
  String get label_store_password_in_session => 'Store OpenPGP key password within a session';

  @override
  String get btn_enable_backward_compatibility => 'Enable backward compatibility';

  @override
  String get error_backward_compatibility_sharing_not_supported => 'The sharing of this file is not supported. The file is encrypted using the old encryption mode. The file must be uploaded and encrypted using the modern encryption mode. Please download and upload the file again.';

  @override
  String get hint_backward_compatibility_aes_key => 'The AES key will be used only to decrypt the files that are encrypted using the old encryption mode. The new files will be encrypted using modern encryption mode.';

  @override
  String get label_delete_folder => 'Delete folder';

  @override
  String get fido_error_invalid_key => 'Invalid security key';

  @override
  String get tfa_label => 'Two Factor Verification';

  @override
  String get tfa_hint_step => 'This extra step is intended to confirm it’s really you trying to sign in';

  @override
  String get fido_btn_use_key => 'Use security key';

  @override
  String get fido_label_connect_your_key => 'Please scan your security key or insert it to the device';

  @override
  String get fido_label_success => 'Success';

  @override
  String get tfa_btn_other_options => 'Other options';

  @override
  String get tfa_btn_use_backup_code => 'Use Backup code';

  @override
  String get tfa_btn_use_auth_app => 'Use Authenticator app';

  @override
  String get tfa_btn_use_security_key => 'Use your Security key';

  @override
  String get tfa_label_hint_security_options => 'Security options available';

  @override
  String get fido_label_touch_your_key => 'Touch you security key';

  @override
  String get fido_hint_follow_the_instructions => 'Please follow the instructions in the popup dialog';

  @override
  String get fido_error_title => 'There was a problem';

  @override
  String get fido_error_hint => 'Try using your security key again or try another way to verify it\'s you';

  @override
  String get fido_btn_try_again => 'Try again';

  @override
  String get tfa_input_hint_code_from_app => 'Specify verification code from the Authenticator app';

  @override
  String get btn_login_back_to_login => 'Back to login';

  @override
  String get input_2fa_pin => 'Verification code';

  @override
  String get btn_verify_pin => 'Verify';

  @override
  String get error_invalid_pin => 'Invalid code';

  @override
  String get tfa_label_enter_backup_code => 'Enter one of your 8-character backup codes';

  @override
  String get tfa_input_backup_code => 'Backup code';

  @override
  String get tfa_label_trust_device => 'You\'re all set';

  @override
  String tfa_check_box_trust_device(String daysCount) {
    return 'Don\'t ask again on this device for $daysCount days';
  }

  @override
  String get tfa_button_continue => 'Continue';

  @override
  String get logger_label_show_debug_view => 'Show debug view';

  @override
  String get logger_btn_delete_all => 'Delete all';

  @override
  String get logger_hint_delete_all_logs => 'Are you sure you want to delete all logs';

  @override
  String get logger_hint_delete_log => 'Are you sure you want to delete the file';

  @override
  String get clear_cache_during_logout => 'Delete cached data and keys';

  @override
  String get btn_encryption_personal_storage => 'Allow encrypt files in Personal Storage';

  @override
  String get hint_pgp_no_keys_to_import => 'The text contains no keys that can be imported.';

  @override
  String get label_encryption_module_not_exist => 'The encryption module\nis not available on the backend';

  @override
  String get hint_pgp_external_private_keys => 'External private keys are not supported and will not be imported';

  @override
  String get label_leave_share => 'Leave share';

  @override
  String get label_leave_share_of => 'Leave share of the ';

  @override
  String get label_share_history_title => 'Shared file activity history';

  @override
  String get hint_select_teammate => 'Select teammate';

  @override
  String get label_no_share => 'No shares yet';

  @override
  String get label_show_history => 'Show history';

  @override
  String get clear_cache_during_login => 'When changing the user, it is necessary to clear the cached data and keys from the previous user.';
}
