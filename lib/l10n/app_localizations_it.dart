// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get mail => 'Posta';

  @override
  String get contacts => 'Contatti';

  @override
  String get files => 'File';

  @override
  String get calendar => 'Calendario';

  @override
  String get tasks => 'Attività';

  @override
  String get storage_personal => 'Personale';

  @override
  String get storage_corporate => 'Aziendale';

  @override
  String get storage_shared => 'Condiviso';

  @override
  String get storage_encrypted => 'Crittografato';

  @override
  String get storage_favorite => 'Preferiti';

  @override
  String get storage_trash => 'Cestino';

  @override
  String get cancel => 'Annulla';

  @override
  String quota_using(String progress, String limit) {
    return 'Stai utilizzando il $progress% del tuo $limit';
  }

  @override
  String get offline_mode => 'Modalità offline';

  @override
  String get settings => 'Impostazioni';

  @override
  String get log_out => 'Disconnetti';

  @override
  String no_route(String name) {
    return 'Nessuna rotta definita per $name';
  }

  @override
  String get common => 'Comune';

  @override
  String get encryption => 'Crittografia';

  @override
  String get openPGP => 'OpenPGP';

  @override
  String get storage_info => 'Informazioni archiviazione';

  @override
  String get about => 'Informazioni';

  @override
  String version(String version) {
    return 'Versione $version';
  }

  @override
  String get terms => 'Termini di servizio';

  @override
  String get privacy_policy => 'Informativa sulla privacy';

  @override
  String get clear_cache => 'Cancella cache';

  @override
  String get confirm_delete => 'Sei sicuro di voler eliminare tutti i file e le immagini memorizzati nella cache? Questo non influenzerà i file salvati per l\'uso offline.';

  @override
  String get clear => 'Cancella';

  @override
  String get cache_cleared_success => 'Cache cancellata con successo';

  @override
  String get app_theme => 'Tema dell\'app';

  @override
  String get switch_language => 'Lingua';

  @override
  String get system_language => 'Sistema';

  @override
  String get system_theme => 'Tema di sistema';

  @override
  String get dark_theme => 'Scuro';

  @override
  String get light_theme => 'Chiaro';

  @override
  String get encryption_description => 'I file vengono crittografati/decrittografati direttamente su questo dispositivo, anche il server stesso non può accedere al contenuto originale dei file crittografati in modo paranoico. Il metodo di crittografia è AES256.';

  @override
  String get delete_encryption_key_success => 'La chiave di crittografia è stata eliminata con successo.';

  @override
  String get delete_key => 'Elimina chiave';

  @override
  String get share_key => 'Condividi chiave';

  @override
  String get download_key => 'Scarica chiave';

  @override
  String get encryption_export_description => 'Per accedere ai file crittografati su altri dispositivi/browser, esporta la chiave e poi importala su un altro dispositivo/browser.';

  @override
  String get encryption_keys => 'Chiave di crittografia:';

  @override
  String get generate_keys => 'Genera chiavi';

  @override
  String get key_not_found_in_file => 'Impossibile trovare una chiave in questo file';

  @override
  String get import_encryption_key_success => 'La chiave di crittografia è stata importata con successo';

  @override
  String get import_key_from_file => 'Importa chiave da file';

  @override
  String get import_key_from_text => 'Importa chiave da testo';

  @override
  String get need_to_set_encryption_key => 'Per iniziare a utilizzare la crittografia dei file caricati è necessario impostare una chiave di crittografia.';

  @override
  String get oK => 'OK';

  @override
  String key_downloaded_into(String dir) {
    return 'La chiave è stata scaricata in: $dir';
  }

  @override
  String get import_key => 'Importa chiave';

  @override
  String get generate_key => 'Genera chiave';

  @override
  String get add_key_progress => 'Aggiunta chiave di crittografia...';

  @override
  String get key_name => 'Nome chiave';

  @override
  String get key_text => 'Testo chiave';

  @override
  String get import => 'Importa';

  @override
  String get generate => 'Genera';

  @override
  String get delete_key_description => 'Attenzione! Non sarai più in grado di decrittografare i file crittografati su questo dispositivo a meno che non importi nuovamente questa chiave.';

  @override
  String get delete => 'Elimina';

  @override
  String get download_key_progress => 'Download della chiave...';

  @override
  String get download_confirm => 'Sei sicuro di voler scaricare questa chiave?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get select_length => 'Seleziona lunghezza';

  @override
  String get length => 'Lunghezza';

  @override
  String get close => 'Chiudi';

  @override
  String get password_is_empty => 'la password è vuota';

  @override
  String get already_have_key => 'Hai già la/le chiave/i per questa email';

  @override
  String get already_have_keys => 'Le chiavi che sono già nel sistema sono disattivate.';

  @override
  String get import_selected_keys => 'Importa chiavi selezionate';

  @override
  String get check_keys => 'Controlla chiavi';

  @override
  String get all_public_keys => 'Tutte le chiavi pubbliche';

  @override
  String get send_all => 'Invia tutto';

  @override
  String get download_all => 'Scarica tutto';

  @override
  String downloading_to(String path) {
    return 'Download di $path';
  }

  @override
  String get private_key => 'Chiave privata';

  @override
  String get public_key => 'Chiave pubblica';

  @override
  String get share => 'Condividi';

  @override
  String get download => 'Scarica';

  @override
  String confirm_delete_pgp_key(String email) {
    return 'Sei sicuro di voler eliminare la chiave OpenPGP per $email?';
  }

  @override
  String get public_keys => 'Chiavi pubbliche';

  @override
  String get private_keys => 'Chiavi private';

  @override
  String get export_all_public_keys => 'Esporta tutte le chiavi pubbliche';

  @override
  String get import_keys_from_text => 'Importa chiavi da testo';

  @override
  String get import_keys_from_file => 'Importa chiavi da file';

  @override
  String get offline_information_is_not_available => 'Queste informazioni non sono disponibili quando sei offline.';

  @override
  String get information_is_not_available => 'Queste informazioni non sono disponibili al momento.';

  @override
  String available_space(String format) {
    return 'Spazio disponibile: $format';
  }

  @override
  String used_space(String used, String limit) {
    return 'Spazio utilizzato: $used su $limit';
  }

  @override
  String get upgrade_now => 'Aggiorna ora';

  @override
  String get has_public_link => 'Ha link pubblico';

  @override
  String get available_offline => 'Disponibile offline';

  @override
  String get synched_successfully => 'File sincronizzato con successo';

  @override
  String get synch_file_progress => 'Sincronizzazione file...';

  @override
  String downloaded_successfully_into(String name, String path) {
    return '$name scaricato con successo in: $path';
  }

  @override
  String downloading(String name) {
    return 'Download di $name';
  }

  @override
  String get set_any_encryption_key => 'Hai abilitato la crittografia dei file caricati ma non hai impostato alcuna chiave di crittografia.';

  @override
  String get need_an_encryption_to_share => 'Hai bisogno di una chiave di crittografia per condividere i file.';

  @override
  String get need_an_encryption_to_download => 'Hai bisogno di una chiave di crittografia per scaricare i file.';

  @override
  String get search => 'Cerca';

  @override
  String get add_folder => 'Aggiungi cartella';

  @override
  String get move_file_or_folder => 'Sposta file/cartelle';

  @override
  String get copy => 'Copia';

  @override
  String get move => 'Sposta';

  @override
  String get link_coppied_to_clipboard => 'Link copiato negli appunti';

  @override
  String get public_link_access => 'Accesso link pubblico';

  @override
  String get copy_public_link => 'Copia link pubblico';

  @override
  String get btn_shareable_link => 'Crea link condivisibile';

  @override
  String get btn_encrypted_shareable_link => 'Condividi file crittografato';

  @override
  String get has_PGP_public_key => 'Il destinatario selezionato ha una chiave pubblica PGP. I dati possono essere crittografati utilizzando questa chiave.';

  @override
  String get has_no_PGP_public_key => 'Il destinatario selezionato non ha una chiave pubblica PGP. La crittografia basata su chiave non è consentita.';

  @override
  String get encryption_type => 'Tipo di crittografia:';

  @override
  String get key_will_be_used => 'Verrà utilizzata la crittografia basata su chiave';

  @override
  String get password_will_be_used => 'Verrà utilizzata la crittografia basata su password';

  @override
  String get encrypt => 'Crittografa';

  @override
  String get key_based => 'Basata su chiave';

  @override
  String get password_based => 'Basata su password';

  @override
  String get not_have_recipiens => 'Nessun destinatario specificato';

  @override
  String get select_recipient => 'Seleziona destinatario:';

  @override
  String get cant_load_recipients => 'Impossibile caricare i destinatari:';

  @override
  String get try_again => 'Riprova';

  @override
  String get no_name => 'Nessun nome';

  @override
  String encrypted_using_key(String user) {
    return 'Il file è crittografato utilizzando la chiave pubblica PGP di $user. Puoi inviare il link tramite email crittografata.';
  }

  @override
  String get encrypted_using_password => 'Se non invii l\'email ora, conserva la password da qualche parte. Non sarai in grado di recuperarla altrimenti.';

  @override
  String get add_new_folder => 'Aggiungi nuova cartella';

  @override
  String adding_folder(String name) {
    return 'Aggiunta cartella $name';
  }

  @override
  String get enter_folder_name => 'Inserisci nome cartella';

  @override
  String get add => 'Aggiungi';

  @override
  String get file => 'file';

  @override
  String get folder => 'cartella';

  @override
  String get delete_files => 'Elimina file';

  @override
  String get delete_file => 'Elimina file';

  @override
  String confirm_delete_file(String file) {
    return 'Sei sicuro di voler eliminare $file';
  }

  @override
  String these_files(String count) {
    return 'questi $count file/cartelle ';
  }

  @override
  String this_file(String name) {
    return 'questo $name?';
  }

  @override
  String get offline => 'Offline';

  @override
  String get copy_or_move => 'Copia/Sposta';

  @override
  String get rename => 'Rinomina';

  @override
  String renaming_to(String name) {
    return 'Rinominando in $name';
  }

  @override
  String get enter_new_name => 'Inserisci nuovo nome';

  @override
  String get share_file => 'Condividi file';

  @override
  String get getting_file_progress => 'Ottenimento file per la condivisione...';

  @override
  String get decrypt_error => 'Si è verificato un errore durante il processo di decrittografia. Forse questo file è stato crittografato con un\'altra chiave.';

  @override
  String get file_is_damaged => 'Si è verificato un errore. Forse questo file è danneggiato.';

  @override
  String get encrypted => 'Crittografato';

  @override
  String get open_PDF => 'Apri PDF';

  @override
  String get please_wait_until_loading => 'Attendi fino al termine del caricamento del file';

  @override
  String get delete_from_offline => 'Elimina file da offline';

  @override
  String get filename => 'Nome file';

  @override
  String get size => 'Dimensione';

  @override
  String get created => 'Creato';

  @override
  String get location => 'Posizione';

  @override
  String get owner => 'Proprietario';

  @override
  String get need_an_encryption_to_uploading => 'È necessario impostare una chiave di crittografia prima di caricare i file.';

  @override
  String get successfully_uploaded => 'File caricato con successo';

  @override
  String get no_internet_connection => 'Nessuna connessione internet';

  @override
  String get retry => 'Riprova';

  @override
  String get go_offline => 'Vai offline';

  @override
  String get no_results => 'Nessun risultato';

  @override
  String get empty_here => 'Vuoto qui';

  @override
  String get upgrade_your_plan => 'Le app mobili non sono consentite nel tuo piano di fatturazione.';

  @override
  String get please_upgrade_your_plan => 'Le app mobili non sono consentite nel tuo piano di fatturazione.\nSi prega di aggiornare il piano.';

  @override
  String get back_to_login => 'Torna al login';

  @override
  String get please_enter_hostname => 'Inserisci il nome host';

  @override
  String get please_enter_email => 'Inserisci email';

  @override
  String get please_enter_password => 'Inserisci password';

  @override
  String get enter_host => 'Impossibile rilevare il dominio da questa email, specifica manualmente l\'URL del tuo server.';

  @override
  String get login_form_title => 'Accedi';

  @override
  String get host => 'Host';

  @override
  String get login => 'Login';

  @override
  String get registration_link_hint => 'Non hai ancora un account?';

  @override
  String get registration_link_text => 'Registrati ora';

  @override
  String get encrypted_file_link => 'Link pubblico file crittografato:';

  @override
  String get send => 'Invia tramite email';

  @override
  String get send_encrypted => 'Invia tramite email crittografata';

  @override
  String get upload => 'Carica';

  @override
  String get encrypt_error => 'Errore di crittografia';

  @override
  String get encrypted_file_password => 'Password file crittografato';

  @override
  String get create_link => 'Crea link condivisibile';

  @override
  String get create_encrypt_link => 'Crea link pubblico protetto';

  @override
  String get encrypt_link => 'Proteggi link pubblico con password';

  @override
  String get public_link => 'Link pubblico';

  @override
  String get remove_link => 'Rimuovi link';

  @override
  String get send_to => 'Invia a..';

  @override
  String get recipient => 'Destinatario';

  @override
  String get encrypted_mail_using_key => 'Puoi inviare il link e la password tramite email.';

  @override
  String get send_email => 'Puoi inviare il link tramite email.';

  @override
  String get sending => 'Invio..';

  @override
  String get sending_complete => 'Invio completato';

  @override
  String get failed => 'Fallito';

  @override
  String get keys_not_found => 'Chiavi non trovate';

  @override
  String sign_with_not_key(String data) {
    return '$data non può essere firmato perché la chiave privata non è stata aggiunta.';
  }

  @override
  String get invalid_password => 'Password non valida';

  @override
  String get sign_email => 'Aggiungi firma digitale';

  @override
  String get sign_file_email => 'Firma il file e invia email';

  @override
  String get data => 'dati';

  @override
  String sign_data_with_not_key(String data) {
    return 'Non firmerò i $data perché non hai una chiave privata PGP.';
  }

  @override
  String sign_mail_with_not_key(String data) {
    return 'I $data non saranno firmati perché non hai una chiave privata PGP.';
  }

  @override
  String get password_sign => 'Per la crittografia basata su password la firma PGP non è supportata.';

  @override
  String get email_signed => 'L\'email sarà firmata utilizzando la tua chiave privata.';

  @override
  String get data_signed => 'Firmerò i dati con la tua chiave privata.';

  @override
  String data_not_signed(String data) {
    return 'I $data non saranno firmati.';
  }

  @override
  String get protected_public_link => 'Link pubblico protetto';

  @override
  String get send_public_link_to => 'Invia link pubblico a';

  @override
  String get copy_password => 'Puoi inviare il link tramite email. La password deve essere inviata utilizzando un canale diverso.\n\nSarai in grado di recuperare la password quando necessario.';

  @override
  String get copy_encrypted_password => 'Puoi inviare il link tramite email. La password deve essere inviata utilizzando un canale diverso.\n\nConserva la password da qualche parte. Non sarai in grado di recuperarla altrimenti.';

  @override
  String encrypted_sign_using_key(String user) {
    return 'Il file è crittografato utilizzando la chiave pubblica PGP di $user. Puoi inviare il link tramite email crittografata firmata digitalmente.';
  }

  @override
  String get email_not_signed => 'L\'email non sarà firmata.';

  @override
  String get two_factor_auth => 'Il tuo account è protetto con\nAutenticazione a Due Fattori.\nInserisci il codice PIN.';

  @override
  String get pin => 'PIN';

  @override
  String get verify_pin => 'Verifica pin';

  @override
  String get invalid_pin => 'PIN non valido';

  @override
  String get upload_file => 'Carica file';

  @override
  String upload_files(String count) {
    return 'Carica $count file';
  }

  @override
  String get login_to_continue => 'Accedi per continuare';

  @override
  String get confirm_exit => 'Sei sicuro di voler uscire?';

  @override
  String get exit => 'Esci';

  @override
  String get error_required_pgp_key => 'Chiave PGP richiesta';

  @override
  String get label_required_pgp_key => 'Chiave PGP richiesta';

  @override
  String hint_upload_encrypt_ask(String name) {
    return 'Crittografare \'$name\'?';
  }

  @override
  String get btn_do_not_encrypt => 'Non crittografare';

  @override
  String get label_encryption_always_in_encryption_folder => 'Sempre nella cartella Crittografata';

  @override
  String get label_encryption_always => 'Sempre';

  @override
  String get label_encryption_ask => 'Chiedimi';

  @override
  String get label_encryption_never => 'Mai';

  @override
  String get label_encryption_enable_paranoid_encryption => 'Abilita Crittografia Paranoica';

  @override
  String get btn_encryption_enable => 'Abilita Crittografia Paranoica';

  @override
  String get label_encryption_mode => 'Crittografa file caricati';

  @override
  String get label_save => 'Salva';

  @override
  String get label_encryption_password_for_pgp_key => 'Password richiesta per chiave PGP';

  @override
  String get label_pgp_import_key => 'Importa chiavi';

  @override
  String get hint_pgp_already_have_keys => 'Le chiavi che sono già nel sistema sono disattivate.';

  @override
  String get hint_pgp_your_keys => 'Le tue chiavi';

  @override
  String get hint_pgp_keys_will_be_import_to_contacts => 'Le chiavi saranno importate nei contatti';

  @override
  String get btn_pgp_import_selected_key => 'Importa chiavi selezionate';

  @override
  String get label_pgp_contact_public_keys => 'Chiavi pubbliche esterne';

  @override
  String error_pgp_required_key(String user) {
    return 'Nessuna chiave privata trovata per l\'utente $user.';
  }

  @override
  String get label_share_with_teammates => 'Condividi con i compagni di squadra';

  @override
  String get hint_pgp_share_warning => 'Stai per condividere la tua chiave privata PGP. La chiave deve essere tenuta lontana da terze parti. Vuoi continuare?';

  @override
  String get label_pgp_share_warning => 'Avviso';

  @override
  String get hint_share_folder => 'I file crittografati non saranno disponibili nella cartella condivisa.';

  @override
  String get input_who_cas_see => 'Chi può vedere';

  @override
  String get input_who_cas_edit => 'Chi può modificare';

  @override
  String get btn_show_encrypt => 'Mostra';

  @override
  String get label_store_password_in_session => 'Memorizza la password della chiave OpenPGP all\'interno di una sessione';

  @override
  String get btn_enable_backward_compatibility => 'Abilita compatibilità con le versioni precedenti';

  @override
  String get error_backward_compatibility_sharing_not_supported => 'La condivisione di questo file non è supportata. Il file è crittografato utilizzando la vecchia modalità di crittografia. Il file deve essere caricato e crittografato utilizzando la modalità di crittografia moderna. Scarica e carica nuovamente il file.';

  @override
  String get hint_backward_compatibility_aes_key => 'La chiave AES sarà utilizzata solo per decrittografare i file che sono crittografati utilizzando la vecchia modalità di crittografia. I nuovi file saranno crittografati utilizzando la modalità di crittografia moderna.';

  @override
  String get label_delete_folder => 'Elimina cartella';

  @override
  String get fido_error_invalid_key => 'Chiave di sicurezza non valida';

  @override
  String get tfa_label => 'Verifica a Due Fattori';

  @override
  String get tfa_hint_step => 'Questo passaggio aggiuntivo è inteso per confermare che sei davvero tu che stai cercando di accedere';

  @override
  String get fido_btn_use_key => 'Usa chiave di sicurezza';

  @override
  String get fido_label_connect_your_key => 'Scansiona la tua chiave di sicurezza o inseriscila nel dispositivo';

  @override
  String get fido_label_success => 'Successo';

  @override
  String get tfa_btn_other_options => 'Altre opzioni';

  @override
  String get tfa_btn_use_backup_code => 'Usa codice di backup';

  @override
  String get tfa_btn_use_auth_app => 'Usa app Authenticator';

  @override
  String get tfa_btn_use_security_key => 'Usa la tua chiave di sicurezza';

  @override
  String get tfa_label_hint_security_options => 'Opzioni di sicurezza disponibili';

  @override
  String get fido_label_touch_your_key => 'Tocca la tua chiave di sicurezza';

  @override
  String get fido_hint_follow_the_instructions => 'Segui le istruzioni nella finestra di dialogo popup';

  @override
  String get fido_error_title => 'C\'è stato un problema';

  @override
  String get fido_error_hint => 'Prova a utilizzare nuovamente la tua chiave di sicurezza o prova un altro modo per verificare che sei tu';

  @override
  String get fido_btn_try_again => 'Riprova';

  @override
  String get tfa_input_hint_code_from_app => 'Specifica il codice di verifica dall\'app Authenticator';

  @override
  String get btn_login_back_to_login => 'Torna al login';

  @override
  String get input_2fa_pin => 'Codice di verifica';

  @override
  String get btn_verify_pin => 'Verifica';

  @override
  String get error_invalid_pin => 'Codice non valido';

  @override
  String get tfa_label_enter_backup_code => 'Inserisci uno dei tuoi codici di backup a 8 caratteri';

  @override
  String get tfa_input_backup_code => 'Codice di backup';

  @override
  String get tfa_label_trust_device => 'Sei a posto';

  @override
  String tfa_check_box_trust_device(String daysCount) {
    return 'Non chiedere più su questo dispositivo per $daysCount giorni';
  }

  @override
  String get tfa_button_continue => 'Continua';

  @override
  String get logger_label_show_debug_view => 'Mostra vista debug';

  @override
  String get logger_btn_delete_all => 'Elimina tutto';

  @override
  String get logger_hint_delete_all_logs => 'Sei sicuro di voler eliminare tutti i log';

  @override
  String get logger_hint_delete_log => 'Sei sicuro di voler eliminare il file';

  @override
  String get clear_cache_during_logout => 'Elimina dati memorizzati nella cache e chiavi';

  @override
  String get btn_encryption_personal_storage => 'Consenti crittografia file nell\'Archiviazione Personale';

  @override
  String get hint_pgp_no_keys_to_import => 'Il testo non contiene chiavi che possono essere importate.';

  @override
  String get label_encryption_module_not_exist => 'Il modulo di crittografia\nnon è disponibile sul backend';

  @override
  String get hint_pgp_external_private_keys => 'Le chiavi private esterne non sono supportate e non saranno importate';

  @override
  String get label_leave_share => 'Lascia condivisione';

  @override
  String get label_leave_share_of => 'Lascia condivisione di ';

  @override
  String get label_share_history_title => 'Cronologia attività file condiviso';

  @override
  String get hint_select_teammate => 'Seleziona compagno di squadra';

  @override
  String get label_no_share => 'Nessuna condivisione ancora';

  @override
  String get label_show_history => 'Mostra cronologia';

  @override
  String get clear_cache_during_login => 'Quando si cambia utente, è necessario cancellare i dati memorizzati nella cache e le chiavi dell\'utente precedente.';

  @override
  String get settings_delete_account => 'Elimina account';
}
