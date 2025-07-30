// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get mail => 'E-Mail';

  @override
  String get contacts => 'Kontakte';

  @override
  String get files => 'Dateien';

  @override
  String get calendar => 'Kalender';

  @override
  String get tasks => 'Aufgaben';

  @override
  String get storage_personal => 'Persönlich';

  @override
  String get storage_corporate => 'Unternehmen';

  @override
  String get storage_shared => 'Geteilt';

  @override
  String get storage_encrypted => 'Verschlüsselt';

  @override
  String get storage_favorite => 'Favoriten';

  @override
  String get storage_trash => 'Papierkorb';

  @override
  String get cancel => 'Abbrechen';

  @override
  String quota_using(String progress, String limit) {
    return 'Sie verwenden $progress% von Ihrem $limit';
  }

  @override
  String get offline_mode => 'Offline-Modus';

  @override
  String get settings => 'Einstellungen';

  @override
  String get log_out => 'Abmelden';

  @override
  String no_route(String name) {
    return 'Keine Route definiert für $name';
  }

  @override
  String get common => 'Allgemein';

  @override
  String get encryption => 'Verschlüsselung';

  @override
  String get openPGP => 'OpenPGP';

  @override
  String get storage_info => 'Speicher-Informationen';

  @override
  String get about => 'Über';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get terms => 'Nutzungsbedingungen';

  @override
  String get privacy_policy => 'Datenschutzrichtlinie';

  @override
  String get clear_cache => 'Cache leeren';

  @override
  String get confirm_delete => 'Sind Sie sicher, dass Sie alle zwischengespeicherten Dateien und Bilder löschen möchten? Dies wirkt sich nicht auf gespeicherte Dateien für die Offline-Nutzung aus.';

  @override
  String get clear => 'Leeren';

  @override
  String get cache_cleared_success => 'Cache erfolgreich geleert';

  @override
  String get app_theme => 'App-Design';

  @override
  String get switch_language => 'Sprache';

  @override
  String get system_language => 'System';

  @override
  String get system_theme => 'System-Design';

  @override
  String get dark_theme => 'Dunkel';

  @override
  String get light_theme => 'Hell';

  @override
  String get encryption_description => 'Dateien werden direkt auf diesem Gerät verschlüsselt/entschlüsselt, selbst der Server kann nicht auf den ursprünglichen Inhalt von paranoid verschlüsselten Dateien zugreifen. Die Verschlüsselungsmethode ist AES256.';

  @override
  String get delete_encryption_key_success => 'Der Verschlüsselungsschlüssel wurde erfolgreich gelöscht.';

  @override
  String get delete_key => 'Schlüssel löschen';

  @override
  String get share_key => 'Schlüssel teilen';

  @override
  String get download_key => 'Schlüssel herunterladen';

  @override
  String get encryption_export_description => 'Um auf verschlüsselte Dateien auf anderen Geräten/Browsern zuzugreifen, exportieren Sie den Schlüssel und importieren Sie ihn dann auf einem anderen Gerät/Browser.';

  @override
  String get encryption_keys => 'Verschlüsselungsschlüssel:';

  @override
  String get generate_keys => 'Schlüssel generieren';

  @override
  String get key_not_found_in_file => 'Konnte keinen Schlüssel in dieser Datei finden';

  @override
  String get import_encryption_key_success => 'Der Verschlüsselungsschlüssel wurde erfolgreich importiert';

  @override
  String get import_key_from_file => 'Schlüssel aus Datei importieren';

  @override
  String get import_key_from_text => 'Schlüssel aus Text importieren';

  @override
  String get need_to_set_encryption_key => 'Um die Verschlüsselung hochgeladener Dateien zu verwenden, müssen Sie einen Verschlüsselungsschlüssel festlegen.';

  @override
  String get oK => 'OK';

  @override
  String key_downloaded_into(String dir) {
    return 'Der Schlüssel wurde heruntergeladen in: $dir';
  }

  @override
  String get import_key => 'Schlüssel importieren';

  @override
  String get generate_key => 'Schlüssel generieren';

  @override
  String get add_key_progress => 'Verschlüsselungsschlüssel hinzufügen...';

  @override
  String get key_name => 'Schlüsselname';

  @override
  String get key_text => 'Schlüsseltext';

  @override
  String get import => 'Importieren';

  @override
  String get generate => 'Generieren';

  @override
  String get delete_key_description => 'Warnung! Sie können verschlüsselte Dateien auf diesem Gerät nicht mehr entschlüsseln, es sei denn, Sie importieren diesen Schlüssel erneut.';

  @override
  String get delete => 'Löschen';

  @override
  String get download_key_progress => 'Schlüssel wird heruntergeladen...';

  @override
  String get download_confirm => 'Sind Sie sicher, dass Sie diesen Schlüssel herunterladen möchten?';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get select_length => 'Länge auswählen';

  @override
  String get length => 'Länge';

  @override
  String get close => 'Schließen';

  @override
  String get password_is_empty => 'Passwort ist leer';

  @override
  String get already_have_key => 'Sie haben bereits den/die Schlüssel für diese E-Mail';

  @override
  String get already_have_keys => 'Schlüssel, die bereits im System sind, sind ausgegraut.';

  @override
  String get import_selected_keys => 'Ausgewählte Schlüssel importieren';

  @override
  String get check_keys => 'Schlüssel überprüfen';

  @override
  String get all_public_keys => 'Alle öffentlichen Schlüssel';

  @override
  String get send_all => 'Alle senden';

  @override
  String get download_all => 'Alle herunterladen';

  @override
  String downloading_to(String path) {
    return 'Herunterladen nach $path';
  }

  @override
  String get private_key => 'Privater Schlüssel';

  @override
  String get public_key => 'Öffentlicher Schlüssel';

  @override
  String get share => 'Teilen';

  @override
  String get download => 'Herunterladen';

  @override
  String confirm_delete_pgp_key(String email) {
    return 'Sind Sie sicher, dass Sie den OpenPGP-Schlüssel für $email löschen möchten?';
  }

  @override
  String get public_keys => 'Öffentliche Schlüssel';

  @override
  String get private_keys => 'Private Schlüssel';

  @override
  String get export_all_public_keys => 'Alle öffentlichen Schlüssel exportieren';

  @override
  String get import_keys_from_text => 'Schlüssel aus Text importieren';

  @override
  String get import_keys_from_file => 'Schlüssel aus Datei importieren';

  @override
  String get offline_information_is_not_available => 'Diese Information ist nicht verfügbar, wenn Sie offline sind.';

  @override
  String get information_is_not_available => 'Diese Information ist derzeit nicht verfügbar.';

  @override
  String available_space(String format) {
    return 'Verfügbarer Speicherplatz: $format';
  }

  @override
  String used_space(String used, String limit) {
    return 'Verwendeter Speicherplatz: $used von $limit';
  }

  @override
  String get upgrade_now => 'Jetzt upgraden';

  @override
  String get has_public_link => 'Hat öffentlichen Link';

  @override
  String get available_offline => 'Offline verfügbar';

  @override
  String get synched_successfully => 'Datei erfolgreich synchronisiert';

  @override
  String get synch_file_progress => 'Datei wird synchronisiert...';

  @override
  String downloaded_successfully_into(String name, String path) {
    return '$name erfolgreich heruntergeladen nach: $path';
  }

  @override
  String downloading(String name) {
    return '$name wird heruntergeladen';
  }

  @override
  String get set_any_encryption_key => 'Sie haben die Verschlüsselung hochgeladener Dateien aktiviert, aber keinen Verschlüsselungsschlüssel festgelegt.';

  @override
  String get need_an_encryption_to_share => 'Sie benötigen einen Verschlüsselungsschlüssel, um Dateien zu teilen.';

  @override
  String get need_an_encryption_to_download => 'Sie benötigen einen Verschlüsselungsschlüssel, um Dateien herunterzuladen.';

  @override
  String get search => 'Suchen';

  @override
  String get add_folder => 'Ordner hinzufügen';

  @override
  String get move_file_or_folder => 'Dateien/Ordner verschieben';

  @override
  String get copy => 'Kopieren';

  @override
  String get move => 'Verschieben';

  @override
  String get link_coppied_to_clipboard => 'Link in die Zwischenablage kopiert';

  @override
  String get public_link_access => 'Öffentlicher Link-Zugang';

  @override
  String get copy_public_link => 'Öffentlichen Link kopieren';

  @override
  String get btn_shareable_link => 'Teilbaren Link erstellen';

  @override
  String get btn_encrypted_shareable_link => 'Verschlüsselte Datei teilen';

  @override
  String get has_PGP_public_key => 'Der ausgewählte Empfänger hat einen PGP-öffentlichen Schlüssel. Die Daten können mit diesem Schlüssel verschlüsselt werden.';

  @override
  String get has_no_PGP_public_key => 'Der ausgewählte Empfänger hat keinen PGP-öffentlichen Schlüssel. Die schlüsselbasierte Verschlüsselung ist nicht erlaubt.';

  @override
  String get encryption_type => 'Verschlüsselungstyp:';

  @override
  String get key_will_be_used => 'Die schlüsselbasierte Verschlüsselung wird verwendet';

  @override
  String get password_will_be_used => 'Die passwortbasierte Verschlüsselung wird verwendet';

  @override
  String get encrypt => 'Verschlüsseln';

  @override
  String get key_based => 'Schlüsselbasiert';

  @override
  String get password_based => 'Passwortbasiert';

  @override
  String get not_have_recipiens => 'Keine Empfänger angegeben';

  @override
  String get select_recipient => 'Empfänger auswählen:';

  @override
  String get cant_load_recipients => 'Empfänger können nicht geladen werden:';

  @override
  String get try_again => 'Erneut versuchen';

  @override
  String get no_name => 'Kein Name';

  @override
  String encrypted_using_key(String user) {
    return 'Die Datei ist mit dem PGP-öffentlichen Schlüssel von $user verschlüsselt. Sie können den Link per verschlüsselter E-Mail senden.';
  }

  @override
  String get encrypted_using_password => 'Wenn Sie jetzt keine E-Mail senden, speichern Sie das Passwort irgendwo. Sie können es sonst nicht wiederherstellen.';

  @override
  String get add_new_folder => 'Neuen Ordner hinzufügen';

  @override
  String adding_folder(String name) {
    return 'Ordner $name wird hinzugefügt';
  }

  @override
  String get enter_folder_name => 'Ordnername eingeben';

  @override
  String get add => 'Hinzufügen';

  @override
  String get file => 'Datei';

  @override
  String get folder => 'Ordner';

  @override
  String get delete_files => 'Dateien löschen';

  @override
  String get delete_file => 'Datei löschen';

  @override
  String confirm_delete_file(String file) {
    return 'Sind Sie sicher, dass Sie $file löschen möchten';
  }

  @override
  String these_files(String count) {
    return 'diese $count Dateien/Ordner ';
  }

  @override
  String this_file(String name) {
    return 'diese $name?';
  }

  @override
  String get offline => 'Offline';

  @override
  String get copy_or_move => 'Kopieren/Verschieben';

  @override
  String get rename => 'Umbenennen';

  @override
  String renaming_to(String name) {
    return 'Umbenennen zu $name';
  }

  @override
  String get enter_new_name => 'Neuen Namen eingeben';

  @override
  String get share_file => 'Datei teilen';

  @override
  String get getting_file_progress => 'Datei zum Teilen wird abgerufen...';

  @override
  String get decrypt_error => 'Ein Fehler ist während des Entschlüsselungsprozesses aufgetreten. Möglicherweise wurde diese Datei mit einem anderen Schlüssel verschlüsselt.';

  @override
  String get file_is_damaged => 'Ein Fehler ist aufgetreten. Möglicherweise ist diese Datei beschädigt.';

  @override
  String get encrypted => 'Verschlüsselt';

  @override
  String get open_PDF => 'PDF öffnen';

  @override
  String get please_wait_until_loading => 'Bitte warten Sie, bis die Datei vollständig geladen ist';

  @override
  String get delete_from_offline => 'Datei aus Offline löschen';

  @override
  String get filename => 'Dateiname';

  @override
  String get size => 'Größe';

  @override
  String get created => 'Erstellt';

  @override
  String get location => 'Ort';

  @override
  String get owner => 'Besitzer';

  @override
  String get need_an_encryption_to_uploading => 'Sie müssen einen Verschlüsselungsschlüssel festlegen, bevor Sie Dateien hochladen.';

  @override
  String get successfully_uploaded => 'Datei erfolgreich hochgeladen';

  @override
  String get no_internet_connection => 'Keine Internetverbindung';

  @override
  String get retry => 'Wiederholen';

  @override
  String get go_offline => 'Offline gehen';

  @override
  String get no_results => 'Keine Ergebnisse';

  @override
  String get empty_here => 'Hier ist nichts';

  @override
  String get upgrade_your_plan => 'Mobile Apps sind in Ihrem Abrechnungsplan nicht erlaubt.';

  @override
  String get please_upgrade_your_plan => 'Mobile Apps sind in Ihrem Abrechnungsplan nicht erlaubt.\nBitte upgraden Sie Ihren Plan.';

  @override
  String get back_to_login => 'Zurück zur Anmeldung';

  @override
  String get please_enter_hostname => 'Bitte geben Sie den Hostnamen ein';

  @override
  String get please_enter_email => 'Bitte geben Sie die E-Mail ein';

  @override
  String get please_enter_password => 'Bitte geben Sie das Passwort ein';

  @override
  String get enter_host => 'Konnte die Domain aus dieser E-Mail nicht erkennen, bitte geben Sie Ihre Server-URL manuell an.';

  @override
  String get login_form_title => 'Anmelden';

  @override
  String get host => 'Host';

  @override
  String get login => 'Anmeldung';

  @override
  String get registration_link_hint => 'Noch kein Konto?';

  @override
  String get registration_link_text => 'Jetzt registrieren';

  @override
  String get encrypted_file_link => 'Öffentlicher Link der verschlüsselten Datei:';

  @override
  String get send => 'Per E-Mail senden';

  @override
  String get send_encrypted => 'Per verschlüsselter E-Mail senden';

  @override
  String get upload => 'Hochladen';

  @override
  String get encrypt_error => 'Verschlüsselungsfehler';

  @override
  String get encrypted_file_password => 'Passwort der verschlüsselten Datei';

  @override
  String get create_link => 'Teilbaren Link erstellen';

  @override
  String get create_encrypt_link => 'Geschützten öffentlichen Link erstellen';

  @override
  String get encrypt_link => 'Öffentlichen Link mit Passwort schützen';

  @override
  String get public_link => 'Öffentlicher Link';

  @override
  String get remove_link => 'Link entfernen';

  @override
  String get send_to => 'Senden an..';

  @override
  String get recipient => 'Empfänger';

  @override
  String get encrypted_mail_using_key => 'Sie können den Link und das Passwort per E-Mail senden.';

  @override
  String get send_email => 'Sie können den Link per E-Mail senden.';

  @override
  String get sending => 'Wird gesendet..';

  @override
  String get sending_complete => 'Senden abgeschlossen';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get keys_not_found => 'Schlüssel nicht gefunden';

  @override
  String sign_with_not_key(String data) {
    return '$data kann nicht signiert werden, da der private Schlüssel nicht hinzugefügt wurde.';
  }

  @override
  String get invalid_password => 'Ungültiges Passwort';

  @override
  String get sign_email => 'Digitale Signatur hinzufügen';

  @override
  String get sign_file_email => 'Datei signieren und per E-Mail senden';

  @override
  String get data => 'Daten';

  @override
  String sign_data_with_not_key(String data) {
    return 'Wird die $data nicht signieren, da Sie keinen privaten PGP-Schlüssel haben.';
  }

  @override
  String sign_mail_with_not_key(String data) {
    return 'Die $data werden nicht signiert, da Sie keinen privaten PGP-Schlüssel haben.';
  }

  @override
  String get password_sign => 'Für passwortbasierte Verschlüsselung wird PGP-Signierung nicht unterstützt.';

  @override
  String get email_signed => 'Die E-Mail wird mit Ihrem privaten Schlüssel signiert.';

  @override
  String get data_signed => 'Wird die Daten mit Ihrem privaten Schlüssel signieren.';

  @override
  String data_not_signed(String data) {
    return 'Die $data werden nicht signiert.';
  }

  @override
  String get protected_public_link => 'Geschützter öffentlicher Link';

  @override
  String get send_public_link_to => 'Öffentlichen Link senden an';

  @override
  String get copy_password => 'Sie können den Link per E-Mail senden. Das Passwort muss über einen anderen Kanal gesendet werden.\n\nSie können das Passwort bei Bedarf abrufen.';

  @override
  String get copy_encrypted_password => 'Sie können den Link per E-Mail senden. Das Passwort muss über einen anderen Kanal gesendet werden.\n\nSpeichern Sie das Passwort irgendwo. Sie können es sonst nicht wiederherstellen.';

  @override
  String encrypted_sign_using_key(String user) {
    return 'Die Datei ist mit dem PGP-öffentlichen Schlüssel von $user verschlüsselt. Sie können den Link per digital signierter verschlüsselter E-Mail senden.';
  }

  @override
  String get email_not_signed => 'Die E-Mail wird nicht signiert.';

  @override
  String get two_factor_auth => 'Ihr Konto ist mit\nZwei-Faktor-Authentifizierung geschützt.\nBitte geben Sie den PIN-Code ein.';

  @override
  String get pin => 'PIN';

  @override
  String get verify_pin => 'PIN verifizieren';

  @override
  String get invalid_pin => 'Ungültige PIN';

  @override
  String get upload_file => 'Datei hochladen';

  @override
  String upload_files(String count) {
    return '$count Dateien hochladen';
  }

  @override
  String get login_to_continue => 'Anmelden um fortzufahren';

  @override
  String get confirm_exit => 'Sind Sie sicher, dass Sie beenden möchten?';

  @override
  String get exit => 'Beenden';

  @override
  String get error_required_pgp_key => 'PGP-Schlüssel erforderlich';

  @override
  String get label_required_pgp_key => 'PGP-Schlüssel erforderlich';

  @override
  String hint_upload_encrypt_ask(String name) {
    return '\'$name\' verschlüsseln?';
  }

  @override
  String get btn_do_not_encrypt => 'Nicht verschlüsseln';

  @override
  String get label_encryption_always_in_encryption_folder => 'Immer im verschlüsselten Ordner';

  @override
  String get label_encryption_always => 'Immer';

  @override
  String get label_encryption_ask => 'Mich fragen';

  @override
  String get label_encryption_never => 'Niemals';

  @override
  String get label_encryption_enable_paranoid_encryption => 'Paranoide Verschlüsselung aktivieren';

  @override
  String get btn_encryption_enable => 'Paranoide Verschlüsselung aktivieren';

  @override
  String get label_encryption_mode => 'Hochgeladene Dateien verschlüsseln';

  @override
  String get label_save => 'Speichern';

  @override
  String get label_encryption_password_for_pgp_key => 'Passwort für PGP-Schlüssel erforderlich';

  @override
  String get label_pgp_import_key => 'Schlüssel importieren';

  @override
  String get hint_pgp_already_have_keys => 'Schlüssel, die bereits im System sind, sind ausgegraut.';

  @override
  String get hint_pgp_your_keys => 'Ihre Schlüssel';

  @override
  String get hint_pgp_keys_will_be_import_to_contacts => 'Die Schlüssel werden in die Kontakte importiert';

  @override
  String get btn_pgp_import_selected_key => 'Ausgewählte Schlüssel importieren';

  @override
  String get label_pgp_contact_public_keys => 'Externe öffentliche Schlüssel';

  @override
  String error_pgp_required_key(String user) {
    return 'Kein privater Schlüssel für Benutzer $user gefunden.';
  }

  @override
  String get label_share_with_teammates => 'Mit Teamkollegen teilen';

  @override
  String get hint_pgp_share_warning => 'Sie sind dabei, Ihren privaten PGP-Schlüssel zu teilen. Der Schlüssel muss vor Dritten geschützt werden. Möchten Sie fortfahren?';

  @override
  String get label_pgp_share_warning => 'Warnung';

  @override
  String get hint_share_folder => 'Verschlüsselte Dateien sind im geteilten Ordner nicht verfügbar.';

  @override
  String get input_who_cas_see => 'Wer kann sehen';

  @override
  String get input_who_cas_edit => 'Wer kann bearbeiten';

  @override
  String get btn_show_encrypt => 'Anzeigen';

  @override
  String get label_store_password_in_session => 'OpenPGP-Schlüssel-Passwort in einer Sitzung speichern';

  @override
  String get btn_enable_backward_compatibility => 'Rückwärtskompatibilität aktivieren';

  @override
  String get error_backward_compatibility_sharing_not_supported => 'Das Teilen dieser Datei wird nicht unterstützt. Die Datei ist mit dem alten Verschlüsselungsmodus verschlüsselt. Die Datei muss mit dem modernen Verschlüsselungsmodus hochgeladen und verschlüsselt werden. Bitte laden Sie die Datei herunter und laden Sie sie erneut hoch.';

  @override
  String get hint_backward_compatibility_aes_key => 'Der AES-Schlüssel wird nur verwendet, um Dateien zu entschlüsseln, die mit dem alten Verschlüsselungsmodus verschlüsselt sind. Neue Dateien werden mit dem modernen Verschlüsselungsmodus verschlüsselt.';

  @override
  String get label_delete_folder => 'Ordner löschen';

  @override
  String get fido_error_invalid_key => 'Ungültiger Sicherheitsschlüssel';

  @override
  String get tfa_label => 'Zwei-Faktor-Verifizierung';

  @override
  String get tfa_hint_step => 'Dieser zusätzliche Schritt soll bestätigen, dass Sie es wirklich sind, der sich anzumelden versucht';

  @override
  String get fido_btn_use_key => 'Sicherheitsschlüssel verwenden';

  @override
  String get fido_label_connect_your_key => 'Bitte scannen Sie Ihren Sicherheitsschlüssel oder stecken Sie ihn in das Gerät';

  @override
  String get fido_label_success => 'Erfolg';

  @override
  String get tfa_btn_other_options => 'Andere Optionen';

  @override
  String get tfa_btn_use_backup_code => 'Backup-Code verwenden';

  @override
  String get tfa_btn_use_auth_app => 'Authentifizierungs-App verwenden';

  @override
  String get tfa_btn_use_security_key => 'Ihren Sicherheitsschlüssel verwenden';

  @override
  String get tfa_label_hint_security_options => 'Verfügbare Sicherheitsoptionen';

  @override
  String get fido_label_touch_your_key => 'Berühren Sie Ihren Sicherheitsschlüssel';

  @override
  String get fido_hint_follow_the_instructions => 'Bitte folgen Sie den Anweisungen im Popup-Dialog';

  @override
  String get fido_error_title => 'Es gab ein Problem';

  @override
  String get fido_error_hint => 'Versuchen Sie, Ihren Sicherheitsschlüssel erneut zu verwenden oder versuchen Sie eine andere Methode, um zu verifizieren, dass Sie es sind';

  @override
  String get fido_btn_try_again => 'Erneut versuchen';

  @override
  String get tfa_input_hint_code_from_app => 'Geben Sie den Verifizierungscode aus der Authentifizierungs-App an';

  @override
  String get btn_login_back_to_login => 'Zurück zur Anmeldung';

  @override
  String get input_2fa_pin => 'Verifizierungscode';

  @override
  String get btn_verify_pin => 'Verifizieren';

  @override
  String get error_invalid_pin => 'Ungültiger Code';

  @override
  String get tfa_label_enter_backup_code => 'Geben Sie einen Ihrer 8-stelligen Backup-Codes ein';

  @override
  String get tfa_input_backup_code => 'Backup-Code';

  @override
  String get tfa_label_trust_device => 'Sie sind bereit';

  @override
  String tfa_check_box_trust_device(String daysCount) {
    return 'Auf diesem Gerät $daysCount Tage lang nicht mehr fragen';
  }

  @override
  String get tfa_button_continue => 'Fortfahren';

  @override
  String get logger_label_show_debug_view => 'Debug-Ansicht anzeigen';

  @override
  String get logger_btn_delete_all => 'Alle löschen';

  @override
  String get logger_hint_delete_all_logs => 'Sind Sie sicher, dass Sie alle Protokolle löschen möchten';

  @override
  String get logger_hint_delete_log => 'Sind Sie sicher, dass Sie die Datei löschen möchten';

  @override
  String get clear_cache_during_logout => 'Zwischengespeicherte Daten und Schlüssel löschen';

  @override
  String get btn_encryption_personal_storage => 'Verschlüsselung von Dateien im persönlichen Speicher erlauben';

  @override
  String get hint_pgp_no_keys_to_import => 'Der Text enthält keine Schlüssel, die importiert werden können.';

  @override
  String get label_encryption_module_not_exist => 'Das Verschlüsselungsmodul\nist auf dem Backend nicht verfügbar';

  @override
  String get hint_pgp_external_private_keys => 'Externe private Schlüssel werden nicht unterstützt und werden nicht importiert';

  @override
  String get label_leave_share => 'Freigabe verlassen';

  @override
  String get label_leave_share_of => 'Freigabe verlassen von ';

  @override
  String get label_share_history_title => 'Aktivitätsverlauf der geteilten Datei';

  @override
  String get hint_select_teammate => 'Teamkollegen auswählen';

  @override
  String get label_no_share => 'Noch keine Freigaben';

  @override
  String get label_show_history => 'Verlauf anzeigen';

  @override
  String get clear_cache_during_login => 'Beim Wechseln des Benutzers ist es notwendig, die zwischengespeicherten Daten und Schlüssel des vorherigen Benutzers zu löschen.';

  @override
  String get settings_delete_account => 'Konto löschen';
}
