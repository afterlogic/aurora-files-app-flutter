//ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @mail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get mail;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @quota_using.
  ///
  /// In en, this message translates to:
  /// **'You are using {progress}% of your {limit}'**
  String quota_using(String progress, String limit);

  /// No description provided for @offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offline_mode;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @no_route.
  ///
  /// In en, this message translates to:
  /// **'No route defined for {name}'**
  String no_route(String name);

  /// No description provided for @common.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get common;

  /// No description provided for @encryption.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get encryption;

  /// No description provided for @openPGP.
  ///
  /// In en, this message translates to:
  /// **'OpenPGP'**
  String get openPGP;

  /// No description provided for @storage_info.
  ///
  /// In en, this message translates to:
  /// **'Storage info'**
  String get storage_info;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @clear_cache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clear_cache;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all the cached files and images? This will not affect saved files for offline.'**
  String get confirm_delete;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cache_cleared_success.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cache_cleared_success;

  /// No description provided for @app_theme.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get app_theme;

  /// No description provided for @system_theme.
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get system_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark_theme;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light_theme;

  /// No description provided for @encryption_description.
  ///
  /// In en, this message translates to:
  /// **'Files are encrypted/decrypted right on this device, even the server itself cannot get access to original content of paranoid-encrypted files. Encryption method is AES256.'**
  String get encryption_description;

  /// No description provided for @delete_encryption_key_success.
  ///
  /// In en, this message translates to:
  /// **'The encryption key was successfully deleted.'**
  String get delete_encryption_key_success;

  /// No description provided for @delete_key.
  ///
  /// In en, this message translates to:
  /// **'Delete key'**
  String get delete_key;

  /// No description provided for @share_key.
  ///
  /// In en, this message translates to:
  /// **'Share key'**
  String get share_key;

  /// No description provided for @download_key.
  ///
  /// In en, this message translates to:
  /// **'Download key'**
  String get download_key;

  /// No description provided for @encryption_export_description.
  ///
  /// In en, this message translates to:
  /// **'To access encrypted files on other devices/browsers, export the key and then import it on another device/browser.'**
  String get encryption_export_description;

  /// No description provided for @encryption_keys.
  ///
  /// In en, this message translates to:
  /// **'Encryption key:'**
  String get encryption_keys;

  /// No description provided for @generate_keys.
  ///
  /// In en, this message translates to:
  /// **'Generate keys'**
  String get generate_keys;

  /// No description provided for @key_not_found_in_file.
  ///
  /// In en, this message translates to:
  /// **'Could not find a key in this file'**
  String get key_not_found_in_file;

  /// No description provided for @import_encryption_key_success.
  ///
  /// In en, this message translates to:
  /// **'The encryption key was successfully imported'**
  String get import_encryption_key_success;

  /// No description provided for @import_key_from_file.
  ///
  /// In en, this message translates to:
  /// **'Import key from file'**
  String get import_key_from_file;

  /// No description provided for @import_key_from_text.
  ///
  /// In en, this message translates to:
  /// **'Import key from text'**
  String get import_key_from_text;

  /// No description provided for @need_to_set_encryption_key.
  ///
  /// In en, this message translates to:
  /// **'To start using encryption of uploaded files your need to set an encryption key.'**
  String get need_to_set_encryption_key;

  /// No description provided for @oK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get oK;

  /// No description provided for @key_downloaded_into.
  ///
  /// In en, this message translates to:
  /// **'The key was downloaded into: {dir}'**
  String key_downloaded_into(String dir);

  /// No description provided for @import_key.
  ///
  /// In en, this message translates to:
  /// **'Import key'**
  String get import_key;

  /// No description provided for @generate_key.
  ///
  /// In en, this message translates to:
  /// **'Generate key'**
  String get generate_key;

  /// No description provided for @add_key_progress.
  ///
  /// In en, this message translates to:
  /// **'Adding encryption key...'**
  String get add_key_progress;

  /// No description provided for @key_name.
  ///
  /// In en, this message translates to:
  /// **'Key name'**
  String get key_name;

  /// No description provided for @key_text.
  ///
  /// In en, this message translates to:
  /// **'Key text'**
  String get key_text;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @delete_key_description.
  ///
  /// In en, this message translates to:
  /// **'Warning! You\'ll no longer be able to decrypt encrypted files on this device unless you import this key again.'**
  String get delete_key_description;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @download_key_progress.
  ///
  /// In en, this message translates to:
  /// **'Downloading the key...'**
  String get download_key_progress;

  /// No description provided for @download_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download this key?'**
  String get download_confirm;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @select_length.
  ///
  /// In en, this message translates to:
  /// **'Select length'**
  String get select_length;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @password_is_empty.
  ///
  /// In en, this message translates to:
  /// **'password is empty'**
  String get password_is_empty;

  /// No description provided for @already_have_key.
  ///
  /// In en, this message translates to:
  /// **'You already have the key(s) for this email'**
  String get already_have_key;

  /// No description provided for @already_have_keys.
  ///
  /// In en, this message translates to:
  /// **'Keys which are already in the system are greyed out.'**
  String get already_have_keys;

  /// No description provided for @import_selected_keys.
  ///
  /// In en, this message translates to:
  /// **'Import selected keys'**
  String get import_selected_keys;

  /// No description provided for @check_keys.
  ///
  /// In en, this message translates to:
  /// **'Check keys'**
  String get check_keys;

  /// No description provided for @all_public_keys.
  ///
  /// In en, this message translates to:
  /// **'All public keys'**
  String get all_public_keys;

  /// No description provided for @send_all.
  ///
  /// In en, this message translates to:
  /// **'Send all'**
  String get send_all;

  /// No description provided for @download_all.
  ///
  /// In en, this message translates to:
  /// **'Download all'**
  String get download_all;

  /// No description provided for @downloading_to.
  ///
  /// In en, this message translates to:
  /// **'Downloading {path}'**
  String downloading_to(String path);

  /// No description provided for @private_key.
  ///
  /// In en, this message translates to:
  /// **'Private key'**
  String get private_key;

  /// No description provided for @public_key.
  ///
  /// In en, this message translates to:
  /// **'Public key'**
  String get public_key;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @confirm_delete_pgp_key.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete OpenPGP key for {email}?'**
  String confirm_delete_pgp_key(String email);

  /// No description provided for @public_keys.
  ///
  /// In en, this message translates to:
  /// **'Public keys'**
  String get public_keys;

  /// No description provided for @private_keys.
  ///
  /// In en, this message translates to:
  /// **'Private keys'**
  String get private_keys;

  /// No description provided for @export_all_public_keys.
  ///
  /// In en, this message translates to:
  /// **'Export all public keys'**
  String get export_all_public_keys;

  /// No description provided for @import_keys_from_text.
  ///
  /// In en, this message translates to:
  /// **'Import keys from text'**
  String get import_keys_from_text;

  /// No description provided for @import_keys_from_file.
  ///
  /// In en, this message translates to:
  /// **'Import keys from file'**
  String get import_keys_from_file;

  /// No description provided for @offline_information_is_not_available.
  ///
  /// In en, this message translates to:
  /// **'This information is not available when you\'re offline.'**
  String get offline_information_is_not_available;

  /// No description provided for @information_is_not_available.
  ///
  /// In en, this message translates to:
  /// **'This information is not available at the moment.'**
  String get information_is_not_available;

  /// No description provided for @available_space.
  ///
  /// In en, this message translates to:
  /// **'Available space: {format}'**
  String available_space(String format);

  /// No description provided for @used_space.
  ///
  /// In en, this message translates to:
  /// **'Used space: {used} out of {limit}'**
  String used_space(String used, String limit);

  /// No description provided for @upgrade_now.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get upgrade_now;

  /// No description provided for @has_public_link.
  ///
  /// In en, this message translates to:
  /// **'Has public link'**
  String get has_public_link;

  /// No description provided for @available_offline.
  ///
  /// In en, this message translates to:
  /// **'Available offline'**
  String get available_offline;

  /// No description provided for @synched_successfully.
  ///
  /// In en, this message translates to:
  /// **'File synched successfully'**
  String get synched_successfully;

  /// No description provided for @synch_file_progress.
  ///
  /// In en, this message translates to:
  /// **'Synching file...'**
  String get synch_file_progress;

  /// No description provided for @downloaded_successfully_into.
  ///
  /// In en, this message translates to:
  /// **'{name} downloaded successfully into: {path}'**
  String downloaded_successfully_into(String name, String path);

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {name}'**
  String downloading(String name);

  /// No description provided for @set_any_encryption_key.
  ///
  /// In en, this message translates to:
  /// **'You have enabled encryption of uploaded files but haven\'t set any encryption key.'**
  String get set_any_encryption_key;

  /// No description provided for @need_an_encryption_to_share.
  ///
  /// In en, this message translates to:
  /// **'You need an encryption key to share files.'**
  String get need_an_encryption_to_share;

  /// No description provided for @need_an_encryption_to_download.
  ///
  /// In en, this message translates to:
  /// **'You need an encryption key to download files.'**
  String get need_an_encryption_to_download;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @add_folder.
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get add_folder;

  /// No description provided for @move_file_or_folder.
  ///
  /// In en, this message translates to:
  /// **'Move files/folders'**
  String get move_file_or_folder;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @link_coppied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Link coppied to clipboard'**
  String get link_coppied_to_clipboard;

  /// No description provided for @public_link_access.
  ///
  /// In en, this message translates to:
  /// **'Public link access'**
  String get public_link_access;

  /// No description provided for @copy_public_link.
  ///
  /// In en, this message translates to:
  /// **'Copy public link'**
  String get copy_public_link;

  /// No description provided for @btn_shareable_link.
  ///
  /// In en, this message translates to:
  /// **'Create shareable link'**
  String get btn_shareable_link;

  /// No description provided for @btn_encrypted_shareable_link.
  ///
  /// In en, this message translates to:
  /// **'Share encrypted file'**
  String get btn_encrypted_shareable_link;

  /// No description provided for @has_PGP_public_key.
  ///
  /// In en, this message translates to:
  /// **'Selected recipient has PGP public key. The data can be encrypted using this key.'**
  String get has_PGP_public_key;

  /// No description provided for @has_no_PGP_public_key.
  ///
  /// In en, this message translates to:
  /// **'Selected recipient has no PGP public key. The key based encryption is not allowed.'**
  String get has_no_PGP_public_key;

  /// No description provided for @encryption_type.
  ///
  /// In en, this message translates to:
  /// **'Encryption type:'**
  String get encryption_type;

  /// No description provided for @key_will_be_used.
  ///
  /// In en, this message translates to:
  /// **'The Key based encryption will be used'**
  String get key_will_be_used;

  /// No description provided for @password_will_be_used.
  ///
  /// In en, this message translates to:
  /// **'The Password based encryption will be used'**
  String get password_will_be_used;

  /// No description provided for @encrypt.
  ///
  /// In en, this message translates to:
  /// **'Encrypt'**
  String get encrypt;

  /// No description provided for @key_based.
  ///
  /// In en, this message translates to:
  /// **'Key based'**
  String get key_based;

  /// No description provided for @password_based.
  ///
  /// In en, this message translates to:
  /// **'Password based'**
  String get password_based;

  /// No description provided for @not_have_recipiens.
  ///
  /// In en, this message translates to:
  /// **'No recipients specified'**
  String get not_have_recipiens;

  /// No description provided for @select_recipient.
  ///
  /// In en, this message translates to:
  /// **'Select recipient:'**
  String get select_recipient;

  /// No description provided for @cant_load_recipients.
  ///
  /// In en, this message translates to:
  /// **'Can\'t load recipients:'**
  String get cant_load_recipients;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get no_name;

  /// No description provided for @encrypted_using_key.
  ///
  /// In en, this message translates to:
  /// **'The file is encrypted using {user}\'s PGP public key. You can send the link via encrypted email.'**
  String encrypted_using_key(String user);

  /// No description provided for @encrypted_using_password.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t send email now, store the password somewhere. You will not be able to recover it otherwise.'**
  String get encrypted_using_password;

  /// No description provided for @add_new_folder.
  ///
  /// In en, this message translates to:
  /// **'Add new folder'**
  String get add_new_folder;

  /// No description provided for @adding_folder.
  ///
  /// In en, this message translates to:
  /// **'Adding {name} folder'**
  String adding_folder(String name);

  /// No description provided for @enter_folder_name.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get enter_folder_name;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get file;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'folder'**
  String get folder;

  /// No description provided for @delete_files.
  ///
  /// In en, this message translates to:
  /// **'Delete files'**
  String get delete_files;

  /// No description provided for @delete_file.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get delete_file;

  /// No description provided for @confirm_delete_file.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {file}'**
  String confirm_delete_file(String file);

  /// No description provided for @these_files.
  ///
  /// In en, this message translates to:
  /// **'these {count} files/folders '**
  String these_files(String count);

  /// No description provided for @this_file.
  ///
  /// In en, this message translates to:
  /// **'this {name}?'**
  String this_file(String name);

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @copy_or_move.
  ///
  /// In en, this message translates to:
  /// **'Copy/Move'**
  String get copy_or_move;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renaming_to.
  ///
  /// In en, this message translates to:
  /// **'Renaming to {name}'**
  String renaming_to(String name);

  /// No description provided for @enter_new_name.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enter_new_name;

  /// No description provided for @share_file.
  ///
  /// In en, this message translates to:
  /// **'Share file'**
  String get share_file;

  /// No description provided for @getting_file_progress.
  ///
  /// In en, this message translates to:
  /// **'Getting file for sharing...'**
  String get getting_file_progress;

  /// No description provided for @decrypt_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the decryption process. Perhaps, this file was encrypted with another key.'**
  String get decrypt_error;

  /// No description provided for @file_is_damaged.
  ///
  /// In en, this message translates to:
  /// **'Error occured. Perhaps this file is damaged.'**
  String get file_is_damaged;

  /// No description provided for @encrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// No description provided for @open_PDF.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get open_PDF;

  /// No description provided for @please_wait_until_loading.
  ///
  /// In en, this message translates to:
  /// **'Please wait until the file finishes loading'**
  String get please_wait_until_loading;

  /// No description provided for @delete_from_offline.
  ///
  /// In en, this message translates to:
  /// **'Delete file from offline'**
  String get delete_from_offline;

  /// No description provided for @filename.
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get filename;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @need_an_encryption_to_uploading.
  ///
  /// In en, this message translates to:
  /// **'You need to set an encryption key before uploading files.'**
  String get need_an_encryption_to_uploading;

  /// No description provided for @successfully_uploaded.
  ///
  /// In en, this message translates to:
  /// **'File successfully uploaded'**
  String get successfully_uploaded;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @go_offline.
  ///
  /// In en, this message translates to:
  /// **'Go offline'**
  String get go_offline;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get no_results;

  /// No description provided for @empty_here.
  ///
  /// In en, this message translates to:
  /// **'Empty here'**
  String get empty_here;

  /// No description provided for @upgrade_your_plan.
  ///
  /// In en, this message translates to:
  /// **'Mobile apps are not allowed in your billing plan.'**
  String get upgrade_your_plan;

  /// No description provided for @please_upgrade_your_plan.
  ///
  /// In en, this message translates to:
  /// **'Mobile apps are not allowed in your billing plan.\nPlease upgrade your plan.'**
  String get please_upgrade_your_plan;

  /// No description provided for @back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get back_to_login;

  /// No description provided for @please_enter_hostname.
  ///
  /// In en, this message translates to:
  /// **'Please enter hostname'**
  String get please_enter_hostname;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get please_enter_email;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get please_enter_password;

  /// No description provided for @enter_host.
  ///
  /// In en, this message translates to:
  /// **'Could not detect domain from this email, please specify your server URL manually.'**
  String get enter_host;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @encrypted_file_link.
  ///
  /// In en, this message translates to:
  /// **'Encrypted file public link:'**
  String get encrypted_file_link;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send via email'**
  String get send;

  /// No description provided for @send_encrypted.
  ///
  /// In en, this message translates to:
  /// **'Send via encrypted email'**
  String get send_encrypted;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @encrypt_error.
  ///
  /// In en, this message translates to:
  /// **'Encrypt error'**
  String get encrypt_error;

  /// No description provided for @encrypted_file_password.
  ///
  /// In en, this message translates to:
  /// **'Encrypted file password'**
  String get encrypted_file_password;

  /// No description provided for @create_link.
  ///
  /// In en, this message translates to:
  /// **'Create shareable link'**
  String get create_link;

  /// No description provided for @create_encrypt_link.
  ///
  /// In en, this message translates to:
  /// **'Create protected public link'**
  String get create_encrypt_link;

  /// No description provided for @encrypt_link.
  ///
  /// In en, this message translates to:
  /// **'Protect public link with password'**
  String get encrypt_link;

  /// No description provided for @public_link.
  ///
  /// In en, this message translates to:
  /// **'Public link'**
  String get public_link;

  /// No description provided for @remove_link.
  ///
  /// In en, this message translates to:
  /// **'Remove link'**
  String get remove_link;

  /// No description provided for @send_to.
  ///
  /// In en, this message translates to:
  /// **'Send to..'**
  String get send_to;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @encrypted_mail_using_key.
  ///
  /// In en, this message translates to:
  /// **'You can send the link and the password via email.'**
  String get encrypted_mail_using_key;

  /// No description provided for @send_email.
  ///
  /// In en, this message translates to:
  /// **'You can send the link via email.'**
  String get send_email;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending..'**
  String get sending;

  /// No description provided for @sending_complete.
  ///
  /// In en, this message translates to:
  /// **'Sending complete'**
  String get sending_complete;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @keys_not_found.
  ///
  /// In en, this message translates to:
  /// **'Keys not found'**
  String get keys_not_found;

  /// No description provided for @sign_with_not_key.
  ///
  /// In en, this message translates to:
  /// **'{data} can\'t be signed because the private key has not been added.'**
  String sign_with_not_key(String data);

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalid_password;

  /// No description provided for @sign_email.
  ///
  /// In en, this message translates to:
  /// **'Add digital signature'**
  String get sign_email;

  /// No description provided for @sign_file_email.
  ///
  /// In en, this message translates to:
  /// **'Sign the file and email'**
  String get sign_file_email;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'data'**
  String get data;

  /// No description provided for @sign_data_with_not_key.
  ///
  /// In en, this message translates to:
  /// **'Will not sign the {data} because you don’t have PGP private key.'**
  String sign_data_with_not_key(String data);

  /// No description provided for @sign_mail_with_not_key.
  ///
  /// In en, this message translates to:
  /// **'The {data} will not be signed because you don’t have PGP private key.'**
  String sign_mail_with_not_key(String data);

  /// No description provided for @password_sign.
  ///
  /// In en, this message translates to:
  /// **'For password-based encryption the PGP-signing is not supported.'**
  String get password_sign;

  /// No description provided for @email_signed.
  ///
  /// In en, this message translates to:
  /// **'The email will be signed using your private key.'**
  String get email_signed;

  /// No description provided for @data_signed.
  ///
  /// In en, this message translates to:
  /// **'Will sign the data with your private key.'**
  String get data_signed;

  /// No description provided for @data_not_signed.
  ///
  /// In en, this message translates to:
  /// **'The {data} will not be signed.'**
  String data_not_signed(String data);

  /// No description provided for @protected_public_link.
  ///
  /// In en, this message translates to:
  /// **'Protected public link'**
  String get protected_public_link;

  /// No description provided for @send_public_link_to.
  ///
  /// In en, this message translates to:
  /// **'Send public link to'**
  String get send_public_link_to;

  /// No description provided for @copy_password.
  ///
  /// In en, this message translates to:
  /// **'You can send the link via email. The password must be sent using a different channel.\n\nYou will be able to retrieve the password when needed.'**
  String get copy_password;

  /// No description provided for @copy_encrypted_password.
  ///
  /// In en, this message translates to:
  /// **'You can send the link via email. The password must be sent using a different channel.\n\n  Store the password somewhere. You will not be able to recover it otherwise.'**
  String get copy_encrypted_password;

  /// No description provided for @encrypted_sign_using_key.
  ///
  /// In en, this message translates to:
  /// **'The file is encrypted using {user}\'s PGP public key. You can send the link via digitally signed encrypted email.'**
  String encrypted_sign_using_key(String user);

  /// No description provided for @email_not_signed.
  ///
  /// In en, this message translates to:
  /// **'The email will not be signed.'**
  String get email_not_signed;

  /// No description provided for @two_factor_auth.
  ///
  /// In en, this message translates to:
  /// **'Your account is protected with\nTwo Factor Authentication.\nPlease provide the PIN code.'**
  String get two_factor_auth;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @verify_pin.
  ///
  /// In en, this message translates to:
  /// **'Verify pin'**
  String get verify_pin;

  /// No description provided for @invalid_pin.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get invalid_pin;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get upload_file;

  /// No description provided for @upload_files.
  ///
  /// In en, this message translates to:
  /// **'Upload {count} files'**
  String upload_files(String count);

  /// No description provided for @login_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue'**
  String get login_to_continue;

  /// No description provided for @confirm_exit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to exit?'**
  String get confirm_exit;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @error_required_pgp_key.
  ///
  /// In en, this message translates to:
  /// **'Required PGP key'**
  String get error_required_pgp_key;

  /// No description provided for @label_required_pgp_key.
  ///
  /// In en, this message translates to:
  /// **'Required PGP key'**
  String get label_required_pgp_key;

  /// No description provided for @hint_upload_encrypt_ask.
  ///
  /// In en, this message translates to:
  /// **'Encrypt \'{name}\'?'**
  String hint_upload_encrypt_ask(String name);

  /// No description provided for @btn_do_not_encrypt.
  ///
  /// In en, this message translates to:
  /// **'Do not encrypt'**
  String get btn_do_not_encrypt;

  /// No description provided for @label_encryption_always_in_encryption_folder.
  ///
  /// In en, this message translates to:
  /// **'Always in Encrypted folder'**
  String get label_encryption_always_in_encryption_folder;

  /// No description provided for @label_encryption_always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get label_encryption_always;

  /// No description provided for @label_encryption_ask.
  ///
  /// In en, this message translates to:
  /// **'Ask me'**
  String get label_encryption_ask;

  /// No description provided for @label_encryption_never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get label_encryption_never;

  /// No description provided for @label_encryption_enable_paranoid_encryption.
  ///
  /// In en, this message translates to:
  /// **'Enable Paranoid Encryption'**
  String get label_encryption_enable_paranoid_encryption;

  /// No description provided for @btn_encryption_enable.
  ///
  /// In en, this message translates to:
  /// **'Enable Paranoid Encryption'**
  String get btn_encryption_enable;

  /// No description provided for @label_encryption_mode.
  ///
  /// In en, this message translates to:
  /// **'Encrypt uploaded files'**
  String get label_encryption_mode;

  /// No description provided for @label_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get label_save;

  /// No description provided for @label_encryption_password_for_pgp_key.
  ///
  /// In en, this message translates to:
  /// **'Required password for PGP key'**
  String get label_encryption_password_for_pgp_key;

  /// No description provided for @label_pgp_import_key.
  ///
  /// In en, this message translates to:
  /// **'Import keys'**
  String get label_pgp_import_key;

  /// No description provided for @hint_pgp_already_have_keys.
  ///
  /// In en, this message translates to:
  /// **'Keys which are already in the system are greyed out.'**
  String get hint_pgp_already_have_keys;

  /// No description provided for @hint_pgp_your_keys.
  ///
  /// In en, this message translates to:
  /// **'Your keys'**
  String get hint_pgp_your_keys;

  /// No description provided for @hint_pgp_keys_will_be_import_to_contacts.
  ///
  /// In en, this message translates to:
  /// **'The keys will be imported to contacts'**
  String get hint_pgp_keys_will_be_import_to_contacts;

  /// No description provided for @btn_pgp_import_selected_key.
  ///
  /// In en, this message translates to:
  /// **'Import selected keys'**
  String get btn_pgp_import_selected_key;

  /// No description provided for @label_pgp_contact_public_keys.
  ///
  /// In en, this message translates to:
  /// **'External public keys'**
  String get label_pgp_contact_public_keys;

  /// No description provided for @error_pgp_required_key.
  ///
  /// In en, this message translates to:
  /// **'No private key found for {user} user.'**
  String error_pgp_required_key(String user);

  /// No description provided for @label_share_with_teammates.
  ///
  /// In en, this message translates to:
  /// **'Share with teammates'**
  String get label_share_with_teammates;

  /// No description provided for @hint_pgp_share_warning.
  ///
  /// In en, this message translates to:
  /// **'You are going to share you private PGP key. The key must be kept from the 3rd parties. Do you want to continue?'**
  String get hint_pgp_share_warning;

  /// No description provided for @label_pgp_share_warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get label_pgp_share_warning;

  /// No description provided for @hint_share_folder.
  ///
  /// In en, this message translates to:
  /// **'Encrypted files will not be available in shared folder.'**
  String get hint_share_folder;

  /// No description provided for @input_who_cas_see.
  ///
  /// In en, this message translates to:
  /// **'Who can see'**
  String get input_who_cas_see;

  /// No description provided for @input_who_cas_edit.
  ///
  /// In en, this message translates to:
  /// **'Who can edit'**
  String get input_who_cas_edit;

  /// No description provided for @btn_show_encrypt.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get btn_show_encrypt;

  /// No description provided for @label_store_password_in_session.
  ///
  /// In en, this message translates to:
  /// **'Store OpenPGP key password within a session'**
  String get label_store_password_in_session;

  /// No description provided for @btn_enable_backward_compatibility.
  ///
  /// In en, this message translates to:
  /// **'Enable backward compatibility'**
  String get btn_enable_backward_compatibility;

  /// No description provided for @error_backward_compatibility_sharing_not_supported.
  ///
  /// In en, this message translates to:
  /// **'The sharing of this file is not supported. The file is encrypted using the old encryption mode. The file must be uploaded and encrypted using the modern encryption mode. Please download and upload the file again.'**
  String get error_backward_compatibility_sharing_not_supported;

  /// No description provided for @hint_backward_compatibility_aes_key.
  ///
  /// In en, this message translates to:
  /// **'The AES key will be used only to decrypt the files that are encrypted using the old encryption mode. The new files will be encrypted using modern encryption mode.'**
  String get hint_backward_compatibility_aes_key;

  /// No description provided for @label_delete_folder.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get label_delete_folder;

  /// No description provided for @fido_error_invalid_key.
  ///
  /// In en, this message translates to:
  /// **'Invalid security key'**
  String get fido_error_invalid_key;

  /// No description provided for @tfa_label.
  ///
  /// In en, this message translates to:
  /// **'Two Factor Verification'**
  String get tfa_label;

  /// No description provided for @tfa_hint_step.
  ///
  /// In en, this message translates to:
  /// **'This extra step is intended to confirm it’s really you trying to sign in'**
  String get tfa_hint_step;

  /// No description provided for @fido_btn_use_key.
  ///
  /// In en, this message translates to:
  /// **'Use security key'**
  String get fido_btn_use_key;

  /// No description provided for @fido_label_connect_your_key.
  ///
  /// In en, this message translates to:
  /// **'Please scan your security key or insert it to the device'**
  String get fido_label_connect_your_key;

  /// No description provided for @fido_label_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get fido_label_success;

  /// No description provided for @tfa_btn_other_options.
  ///
  /// In en, this message translates to:
  /// **'Other options'**
  String get tfa_btn_other_options;

  /// No description provided for @tfa_btn_use_backup_code.
  ///
  /// In en, this message translates to:
  /// **'Use Backup code'**
  String get tfa_btn_use_backup_code;

  /// No description provided for @tfa_btn_use_auth_app.
  ///
  /// In en, this message translates to:
  /// **'Use Authenticator app'**
  String get tfa_btn_use_auth_app;

  /// No description provided for @tfa_btn_use_security_key.
  ///
  /// In en, this message translates to:
  /// **'Use your Security key'**
  String get tfa_btn_use_security_key;

  /// No description provided for @tfa_label_hint_security_options.
  ///
  /// In en, this message translates to:
  /// **'Security options available'**
  String get tfa_label_hint_security_options;

  /// No description provided for @fido_label_touch_your_key.
  ///
  /// In en, this message translates to:
  /// **'Touch you security key'**
  String get fido_label_touch_your_key;

  /// No description provided for @fido_hint_follow_the_instructions.
  ///
  /// In en, this message translates to:
  /// **'Please follow the instructions in the popup dialog'**
  String get fido_hint_follow_the_instructions;

  /// No description provided for @fido_error_title.
  ///
  /// In en, this message translates to:
  /// **'There was a problem'**
  String get fido_error_title;

  /// No description provided for @fido_error_hint.
  ///
  /// In en, this message translates to:
  /// **'Try using your security key again or try another way to verify it\'s you'**
  String get fido_error_hint;

  /// No description provided for @fido_btn_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get fido_btn_try_again;

  /// No description provided for @tfa_input_hint_code_from_app.
  ///
  /// In en, this message translates to:
  /// **'Specify verification code from the Authenticator app'**
  String get tfa_input_hint_code_from_app;

  /// No description provided for @btn_login_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get btn_login_back_to_login;

  /// No description provided for @input_2fa_pin.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get input_2fa_pin;

  /// No description provided for @btn_verify_pin.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get btn_verify_pin;

  /// No description provided for @error_invalid_pin.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get error_invalid_pin;

  /// No description provided for @tfa_label_enter_backup_code.
  ///
  /// In en, this message translates to:
  /// **'Enter one of your 8-character backup codes'**
  String get tfa_label_enter_backup_code;

  /// No description provided for @tfa_input_backup_code.
  ///
  /// In en, this message translates to:
  /// **'Backup code'**
  String get tfa_input_backup_code;

  /// No description provided for @tfa_label_trust_device.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set'**
  String get tfa_label_trust_device;

  /// No description provided for @tfa_check_box_trust_device.
  ///
  /// In en, this message translates to:
  /// **'Don\'t ask again on this device for {daysCount} days'**
  String tfa_check_box_trust_device(String daysCount);

  /// No description provided for @tfa_button_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tfa_button_continue;

  /// No description provided for @logger_label_show_debug_view.
  ///
  /// In en, this message translates to:
  /// **'Show debug view'**
  String get logger_label_show_debug_view;

  /// No description provided for @logger_btn_delete_all.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get logger_btn_delete_all;

  /// No description provided for @logger_hint_delete_all_logs.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all logs'**
  String get logger_hint_delete_all_logs;

  /// No description provided for @logger_hint_delete_log.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the file'**
  String get logger_hint_delete_log;

  /// No description provided for @clear_cache_during_logout.
  ///
  /// In en, this message translates to:
  /// **'Delete cached data and keys'**
  String get clear_cache_during_logout;

  /// No description provided for @btn_encryption_personal_storage.
  ///
  /// In en, this message translates to:
  /// **'Allow encrypt files in Personal Storage'**
  String get btn_encryption_personal_storage;

  /// No description provided for @hint_pgp_no_keys_to_import.
  ///
  /// In en, this message translates to:
  /// **'The text contains no keys that can be imported.'**
  String get hint_pgp_no_keys_to_import;

  /// No description provided for @hint_pgp_external_private_keys.
  ///
  /// In en, this message translates to:
  /// **'External private keys are not supported and will not be imported'**
  String get hint_pgp_external_private_keys;

  /// No description provided for @label_leave_share.
  ///
  /// In en, this message translates to:
  /// **'Leave share'**
  String get label_leave_share;

  /// No description provided for @label_leave_share_of.
  ///
  /// In en, this message translates to:
  /// **'Leave share of the '**
  String get label_leave_share_of;

  /// No description provided for @label_share_history_title.
  ///
  /// In en, this message translates to:
  /// **'Shared file activity history'**
  String get label_share_history_title;

  /// No description provided for @hint_select_teammate.
  ///
  /// In en, this message translates to:
  /// **'Select teammate'**
  String get hint_select_teammate;

  /// No description provided for @label_no_share.
  ///
  /// In en, this message translates to:
  /// **'No shares yet'**
  String get label_no_share;

  /// No description provided for @label_show_history.
  ///
  /// In en, this message translates to:
  /// **'Show history'**
  String get label_show_history;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
