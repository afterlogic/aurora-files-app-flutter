import 'dart:ui';

//// ignore_for_file: non_constant_identifier_names
//// ignore_for_file: camel_case_types
//// ignore_for_file: prefer_single_quotes

abstract class S {
  Locale get locale;
  String get mail;
  String get contacts;
  String get files;
  String get calendar;
  String get tasks;
  String get cancel;
  String quota_using(String progress, limit);
  String get offline_mode;
  String get settings;
  String get log_out;
  String no_route(String name);
  String get common;
  String get encryption;
  String get openPGP;
  String get storage_info;
  String get about;
  String version(String version);
  String get terms;
  String get privacy_policy;
  String get clear_cache;
  String get confirm_delete;
  String get clear;
  String get cache_cleared_success;
  String get app_theme;
  String get system_theme;
  String get dark_theme;
  String get light_theme;
  String get encryption_description;
  String get delete_encryption_key_success;
  String get delete_key;
  String get share_key;
  String get download_key;
  String get encryption_export_description;
  String get encryption_keys;
  String get generate_keys;
  String get key_not_found_in_file;
  String get import_encryption_key_success;
  String get import_key_from_file;
  String get import_key_from_text;
  String get need_to_set_encryption_key;
  String get oK;
  String key_downloaded_into(String dir);
  String get import_key;
  String get generate_key;
  String get add_key_progress;
  String get key_name;
  String get key_text;
  String get import;
  String get generate;
  String get delete_key_description;
  String get delete;
  String get download_key_progress;
  String get download_confirm;
  String get email;
  String get password;
  String get select_length;
  String get length;
  String get close;
  String get password_is_empty;
  String get already_have_key;
  String get already_have_keys;
  String get import_selected_keys;
  String get check_keys;
  String get all_public_keys;
  String get send_all;
  String get download_all;
  String downloading_to(String path);
  String get private_key;
  String get public_key;
  String get share;
  String get download;
  String confirm_delete_pgp_key(String email);
  String get public_keys;
  String get private_keys;
  String get export_all_public_keys;
  String get import_keys_from_text;
  String get import_keys_from_file;
  String get offline_information_is_not_available;
  String get information_is_not_available;
  String available_space(String format);
  String used_space(String used, limit);
  String get upgrade_now;
  String get has_public_link;
  String get available_offline;
  String get synched_successfully;
  String get synch_file_progress;
  String downloaded_successfully_into(String name, path);
  String downloading(String name);
  String get set_any_encryption_key;
  String get need_an_encryption_to_share;
  String get need_an_encryption_to_download;
  String get search;
  String get add_folder;
  String get move_file_or_folder;
  String get copy;
  String get move;
  String get link_coppied_to_clipboard;
  String get public_link_access;
  String get copy_public_link;
  String get btn_shareable_link;
  String get btn_encrypted_shareable_link;
  String get has_PGP_public_key;
  String get has_no_PGP_public_key;
  String get encryption_type;
  String get key_will_be_used;
  String get password_will_be_used;
  String get encrypt;
  String get key_based;
  String get password_based;
  String get not_have_recipiens;
  String get select_recipient;
  String get cant_load_recipients;
  String get try_again;
  String get no_name;
  String encrypted_using_key(String user);
  String get encrypted_using_password;
  String get add_new_folder;
  String adding_folder(String name);
  String get enter_folder_name;
  String get add;
  String get file;
  String get folder;
  String get delete_files;
  String get delete_file;
  String confirm_delete_file(String file);
  String these_files(String count);
  String this_file(String name);
  String get offline;
  String get copy_or_move;
  String get rename;
  String renaming_to(String name);
  String get enter_new_name;
  String get share_file;
  String get getting_file_progress;
  String get decrypt_error;
  String get file_is_damaged;
  String get encrypted;
  String get open_PDF;
  String get please_wait_until_loading;
  String get delete_from_offline;
  String get filename;
  String get size;
  String get created;
  String get location;
  String get owner;
  String get need_an_encryption_to_uploading;
  String get successfully_uploaded;
  String get no_internet_connection;
  String get retry;
  String get go_offline;
  String get no_results;
  String get empty_here;
  String get upgrade_your_plan;
  String get please_upgrade_your_plan;
  String get back_to_login;
  String get please_enter_hostname;
  String get please_enter_email;
  String get please_enter_password;
  String get enter_host;
  String get host;
  String get login;
  String get encrypted_file_link;
  String get send;
  String get send_encrypted;
  String get upload;
  String get encrypt_error;
  String get encrypted_file_password;
  String get create_link;
  String get create_encrypt_link;
  String get encrypt_link;
  String get public_link;
  String get remove_link;
  String get send_to;
  String get recipient;
  String get encrypted_mail_using_key;
  String get send_email;
  String get sending;
  String get sending_complete;
  String get failed;
  String get keys_not_found;
  String sign_with_not_key(String data);
  String get invalid_password;
  String get sign_email;
  String get sign_file_email;
  String get data;
  String sign_data_with_not_key(String data);
  String sign_mail_with_not_key(String data);
  String get password_sign;
  String get email_signed;
  String get data_signed;
  String data_not_signed(String data);
  String get protected_public_link;
  String get send_public_link_to;
  String get copy_password;
  String get copy_encrypted_password;
  String encrypted_sign_using_key(String user);
  String get email_not_signed;
  String get two_factor_auth;
  String get pin;
  String get verify_pin;
  String get invalid_pin;
  String get upload_file;
  String upload_files(String count);
  String get login_to_continue;
  String get confirm_exit;
  String get exit;
  String get error_required_pgp_key;
  String get label_required_pgp_key;
  String hint_upload_encrypt_ask(String name);
  String get btn_do_not_encrypt;
  String get label_encryption_always_in_encryption_folder;
  String get label_encryption_always;
  String get label_encryption_ask;
  String get label_encryption_never;
  String get label_encryption_enable_paranoid_encryption;
  String get btn_encryption_enable;
  String get label_encryption_mode;
  String get label_save;
  String get label_encryption_password_for_pgp_key;
  String get label_pgp_import_key;
  String get hint_pgp_already_have_keys;
  String get hint_pgp_your_keys;
  String get hint_pgp_keys_will_be_import_to_contacts;
  String get btn_pgp_import_selected_key;
  String get label_pgp_contact_public_keys;
  String error_pgp_required_key(String user);
  String get label_share_with_teammates;
  String get hint_pgp_share_warning;
  String get label_pgp_share_warning;
  String get hint_share_folder;
  String get input_who_cas_see;
  String get input_who_cas_edit;
  String get btn_show_encrypt;
  String get label_store_password_in_session;
  String get btn_enable_backward_compatibility;
  String get error_backward_compatibility_sharing_not_supported;
  String get hint_backward_compatibility_aes_key;
  String get label_delete_folder;
  String get fido_error_invalid_key;
  String get tfa_label;
  String get tfa_hint_step;
  String get fido_btn_use_key;
  String get fido_label_connect_your_key;
  String get fido_label_success;
  String get tfa_btn_other_options;
  String get tfa_btn_use_backup_code;
  String get tfa_btn_use_auth_app;
  String get tfa_btn_use_security_key;
  String get tfa_label_hint_security_options;
  String get fido_label_touch_your_key;
  String get fido_hint_follow_the_instructions;
  String get fido_error_title;
  String get fido_error_hint;
  String get fido_btn_try_again;
  String get tfa_input_hint_code_from_app;
  String get btn_login_back_to_login;
  String get input_2fa_pin;
  String get btn_verify_pin;
  String get error_invalid_pin;
  String get tfa_label_enter_backup_code;
  String get tfa_input_backup_code;
  String get tfa_label_trust_device;
  String tfa_check_box_trust_device(String daysCount);
  String get tfa_button_continue;
  String get logger_label_show_debug_view;
  String get logger_btn_delete_all;
  String get logger_hint_delete_all_logs;
  String get logger_hint_delete_log;
  String get clear_cache_during_logout;
  String get btn_encryption_personal_storage;
  String get hint_pgp_no_keys_to_import;
  String get hint_pgp_external_private_keys;
  String get label_leave_share;
  String get label_leave_share_of;
  String get label_share_history_title;
  String get hint_select_teammate;
  String get label_no_share;
  String get label_show_history;
}
