// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get mail => 'Courrier';

  @override
  String get contacts => 'Contacts';

  @override
  String get files => 'Fichiers';

  @override
  String get calendar => 'Calendrier';

  @override
  String get tasks => 'Tâches';

  @override
  String get storage_personal => 'Personnel';

  @override
  String get storage_corporate => 'Entreprise';

  @override
  String get storage_shared => 'Partagé';

  @override
  String get storage_encrypted => 'Chiffré';

  @override
  String get storage_favorite => 'Favoris';

  @override
  String get storage_trash => 'Corbeille';

  @override
  String get cancel => 'Annuler';

  @override
  String quota_using(String progress, String limit) {
    return 'Vous utilisez $progress% de votre $limit';
  }

  @override
  String get offline_mode => 'Mode hors ligne';

  @override
  String get settings => 'Paramètres';

  @override
  String get log_out => 'Se déconnecter';

  @override
  String no_route(String name) {
    return 'Aucune route définie pour $name';
  }

  @override
  String get common => 'Commun';

  @override
  String get encryption => 'Chiffrement';

  @override
  String get openPGP => 'OpenPGP';

  @override
  String get storage_info => 'Informations de stockage';

  @override
  String get about => 'À propos';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get terms => 'Conditions d\'utilisation';

  @override
  String get privacy_policy => 'Politique de confidentialité';

  @override
  String get clear_cache => 'Vider le cache';

  @override
  String get confirm_delete => 'Êtes-vous sûr de vouloir supprimer tous les fichiers et images en cache ? Cela n\'affectera pas les fichiers sauvegardés pour une utilisation hors ligne.';

  @override
  String get clear => 'Vider';

  @override
  String get cache_cleared_success => 'Cache vidé avec succès';

  @override
  String get app_theme => 'Thème de l\'application';

  @override
  String get switch_language => 'Langue';

  @override
  String get system_language => 'Système';

  @override
  String get system_theme => 'Thème système';

  @override
  String get dark_theme => 'Sombre';

  @override
  String get light_theme => 'Clair';

  @override
  String get encryption_description => 'Les fichiers sont chiffrés/déchiffrés directement sur cet appareil, même le serveur lui-même ne peut pas accéder au contenu original des fichiers chiffrés de manière paranoïaque. La méthode de chiffrement est AES256.';

  @override
  String get delete_encryption_key_success => 'La clé de chiffrement a été supprimée avec succès.';

  @override
  String get delete_key => 'Supprimer la clé';

  @override
  String get share_key => 'Partager la clé';

  @override
  String get download_key => 'Télécharger la clé';

  @override
  String get encryption_export_description => 'Pour accéder aux fichiers chiffrés sur d\'autres appareils/navigateurs, exportez la clé puis importez-la sur un autre appareil/navigateur.';

  @override
  String get encryption_keys => 'Clé de chiffrement :';

  @override
  String get generate_keys => 'Générer des clés';

  @override
  String get key_not_found_in_file => 'Impossible de trouver une clé dans ce fichier';

  @override
  String get import_encryption_key_success => 'La clé de chiffrement a été importée avec succès';

  @override
  String get import_key_from_file => 'Importer la clé depuis un fichier';

  @override
  String get import_key_from_text => 'Importer la clé depuis le texte';

  @override
  String get need_to_set_encryption_key => 'Pour commencer à utiliser le chiffrement des fichiers téléchargés, vous devez définir une clé de chiffrement.';

  @override
  String get oK => 'OK';

  @override
  String key_downloaded_into(String dir) {
    return 'La clé a été téléchargée dans : $dir';
  }

  @override
  String get import_key => 'Importer la clé';

  @override
  String get generate_key => 'Générer la clé';

  @override
  String get add_key_progress => 'Ajout de la clé de chiffrement...';

  @override
  String get key_name => 'Nom de la clé';

  @override
  String get key_text => 'Texte de la clé';

  @override
  String get import => 'Importer';

  @override
  String get generate => 'Générer';

  @override
  String get delete_key_description => 'Attention ! Vous ne pourrez plus déchiffrer les fichiers chiffrés sur cet appareil à moins d\'importer à nouveau cette clé.';

  @override
  String get delete => 'Supprimer';

  @override
  String get download_key_progress => 'Téléchargement de la clé...';

  @override
  String get download_confirm => 'Êtes-vous sûr de vouloir télécharger cette clé ?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get select_length => 'Sélectionner la longueur';

  @override
  String get length => 'Longueur';

  @override
  String get close => 'Fermer';

  @override
  String get password_is_empty => 'le mot de passe est vide';

  @override
  String get already_have_key => 'Vous avez déjà la/les clé(s) pour cet email';

  @override
  String get already_have_keys => 'Les clés qui sont déjà dans le système sont grisées.';

  @override
  String get import_selected_keys => 'Importer les clés sélectionnées';

  @override
  String get check_keys => 'Vérifier les clés';

  @override
  String get all_public_keys => 'Toutes les clés publiques';

  @override
  String get send_all => 'Envoyer tout';

  @override
  String get download_all => 'Télécharger tout';

  @override
  String downloading_to(String path) {
    return 'Téléchargement vers $path';
  }

  @override
  String get private_key => 'Clé privée';

  @override
  String get public_key => 'Clé publique';

  @override
  String get share => 'Partager';

  @override
  String get download => 'Télécharger';

  @override
  String confirm_delete_pgp_key(String email) {
    return 'Êtes-vous sûr de vouloir supprimer la clé OpenPGP pour $email ?';
  }

  @override
  String get public_keys => 'Clés publiques';

  @override
  String get private_keys => 'Clés privées';

  @override
  String get export_all_public_keys => 'Exporter toutes les clés publiques';

  @override
  String get import_keys_from_text => 'Importer les clés depuis le texte';

  @override
  String get import_keys_from_file => 'Importer les clés depuis un fichier';

  @override
  String get offline_information_is_not_available => 'Cette information n\'est pas disponible lorsque vous êtes hors ligne.';

  @override
  String get information_is_not_available => 'Cette information n\'est pas disponible pour le moment.';

  @override
  String available_space(String format) {
    return 'Espace disponible : $format';
  }

  @override
  String used_space(String used, String limit) {
    return 'Espace utilisé : $used sur $limit';
  }

  @override
  String get upgrade_now => 'Mettre à niveau maintenant';

  @override
  String get has_public_link => 'A un lien public';

  @override
  String get available_offline => 'Disponible hors ligne';

  @override
  String get synched_successfully => 'Fichier synchronisé avec succès';

  @override
  String get synch_file_progress => 'Synchronisation du fichier...';

  @override
  String downloaded_successfully_into(String name, String path) {
    return '$name téléchargé avec succès dans : $path';
  }

  @override
  String downloading(String name) {
    return 'Téléchargement de $name';
  }

  @override
  String get set_any_encryption_key => 'Vous avez activé le chiffrement des fichiers téléchargés mais n\'avez défini aucune clé de chiffrement.';

  @override
  String get need_an_encryption_to_share => 'Vous avez besoin d\'une clé de chiffrement pour partager des fichiers.';

  @override
  String get need_an_encryption_to_download => 'Vous avez besoin d\'une clé de chiffrement pour télécharger des fichiers.';

  @override
  String get search => 'Rechercher';

  @override
  String get add_folder => 'Ajouter un dossier';

  @override
  String get move_file_or_folder => 'Déplacer fichiers/dossiers';

  @override
  String get copy => 'Copier';

  @override
  String get move => 'Déplacer';

  @override
  String get link_coppied_to_clipboard => 'Lien copié dans le presse-papiers';

  @override
  String get public_link_access => 'Accès au lien public';

  @override
  String get copy_public_link => 'Copier le lien public';

  @override
  String get btn_shareable_link => 'Créer un lien partageable';

  @override
  String get btn_encrypted_shareable_link => 'Partager un fichier chiffré';

  @override
  String get has_PGP_public_key => 'Le destinataire sélectionné a une clé publique PGP. Les données peuvent être chiffrées en utilisant cette clé.';

  @override
  String get has_no_PGP_public_key => 'Le destinataire sélectionné n\'a pas de clé publique PGP. Le chiffrement basé sur la clé n\'est pas autorisé.';

  @override
  String get encryption_type => 'Type de chiffrement :';

  @override
  String get key_will_be_used => 'Le chiffrement basé sur la clé sera utilisé';

  @override
  String get password_will_be_used => 'Le chiffrement basé sur le mot de passe sera utilisé';

  @override
  String get encrypt => 'Chiffrer';

  @override
  String get key_based => 'Basé sur la clé';

  @override
  String get password_based => 'Basé sur le mot de passe';

  @override
  String get not_have_recipiens => 'Aucun destinataire spécifié';

  @override
  String get select_recipient => 'Sélectionner le destinataire :';

  @override
  String get cant_load_recipients => 'Impossible de charger les destinataires :';

  @override
  String get try_again => 'Réessayer';

  @override
  String get no_name => 'Aucun nom';

  @override
  String encrypted_using_key(String user) {
    return 'Le fichier est chiffré en utilisant la clé publique PGP de $user. Vous pouvez envoyer le lien via un email chiffré.';
  }

  @override
  String get encrypted_using_password => 'Si vous n\'envoyez pas d\'email maintenant, stockez le mot de passe quelque part. Vous ne pourrez pas le récupérer autrement.';

  @override
  String get add_new_folder => 'Ajouter un nouveau dossier';

  @override
  String adding_folder(String name) {
    return 'Ajout du dossier $name';
  }

  @override
  String get enter_folder_name => 'Entrer le nom du dossier';

  @override
  String get add => 'Ajouter';

  @override
  String get file => 'fichier';

  @override
  String get folder => 'dossier';

  @override
  String get delete_files => 'Supprimer les fichiers';

  @override
  String get delete_file => 'Supprimer le fichier';

  @override
  String confirm_delete_file(String file) {
    return 'Êtes-vous sûr de vouloir supprimer $file';
  }

  @override
  String these_files(String count) {
    return 'ces $count fichiers/dossiers ';
  }

  @override
  String this_file(String name) {
    return 'ce $name ?';
  }

  @override
  String get offline => 'Hors ligne';

  @override
  String get copy_or_move => 'Copier/Déplacer';

  @override
  String get rename => 'Renommer';

  @override
  String renaming_to(String name) {
    return 'Renommage en $name';
  }

  @override
  String get enter_new_name => 'Entrer le nouveau nom';

  @override
  String get share_file => 'Partager le fichier';

  @override
  String get getting_file_progress => 'Obtention du fichier pour le partage...';

  @override
  String get decrypt_error => 'Une erreur s\'est produite pendant le processus de déchiffrement. Peut-être que ce fichier a été chiffré avec une autre clé.';

  @override
  String get file_is_damaged => 'Une erreur s\'est produite. Peut-être que ce fichier est endommagé.';

  @override
  String get encrypted => 'Chiffré';

  @override
  String get open_PDF => 'Ouvrir PDF';

  @override
  String get please_wait_until_loading => 'Veuillez attendre que le fichier finisse de se charger';

  @override
  String get delete_from_offline => 'Supprimer le fichier du mode hors ligne';

  @override
  String get filename => 'Nom du fichier';

  @override
  String get size => 'Taille';

  @override
  String get created => 'Créé';

  @override
  String get location => 'Emplacement';

  @override
  String get owner => 'Propriétaire';

  @override
  String get need_an_encryption_to_uploading => 'Vous devez définir une clé de chiffrement avant de télécharger des fichiers.';

  @override
  String get successfully_uploaded => 'Fichier téléchargé avec succès';

  @override
  String get no_internet_connection => 'Aucune connexion Internet';

  @override
  String get retry => 'Réessayer';

  @override
  String get go_offline => 'Passer hors ligne';

  @override
  String get no_results => 'Aucun résultat';

  @override
  String get empty_here => 'Vide ici';

  @override
  String get upgrade_your_plan => 'Les applications mobiles ne sont pas autorisées dans votre plan de facturation.';

  @override
  String get please_upgrade_your_plan => 'Les applications mobiles ne sont pas autorisées dans votre plan de facturation.\nVeuillez mettre à niveau votre plan.';

  @override
  String get back_to_login => 'Retour à la connexion';

  @override
  String get please_enter_hostname => 'Veuillez entrer le nom d\'hôte';

  @override
  String get please_enter_email => 'Veuillez entrer l\'email';

  @override
  String get please_enter_password => 'Veuillez entrer le mot de passe';

  @override
  String get enter_host => 'Impossible de détecter le domaine à partir de cet email, veuillez spécifier manuellement l\'URL de votre serveur.';

  @override
  String get login_form_title => 'Se connecter';

  @override
  String get host => 'Hôte';

  @override
  String get login => 'Connexion';

  @override
  String get registration_link_hint => 'Pas encore de compte ?';

  @override
  String get registration_link_text => 'S\'inscrire maintenant';

  @override
  String get encrypted_file_link => 'Lien public du fichier chiffré :';

  @override
  String get send => 'Envoyer par email';

  @override
  String get send_encrypted => 'Envoyer par email chiffré';

  @override
  String get upload => 'Télécharger';

  @override
  String get encrypt_error => 'Erreur de chiffrement';

  @override
  String get encrypted_file_password => 'Mot de passe du fichier chiffré';

  @override
  String get create_link => 'Créer un lien partageable';

  @override
  String get create_encrypt_link => 'Créer un lien public protégé';

  @override
  String get encrypt_link => 'Protéger le lien public avec un mot de passe';

  @override
  String get public_link => 'Lien public';

  @override
  String get remove_link => 'Supprimer le lien';

  @override
  String get send_to => 'Envoyer à..';

  @override
  String get recipient => 'Destinataire';

  @override
  String get encrypted_mail_using_key => 'Vous pouvez envoyer le lien et le mot de passe par email.';

  @override
  String get send_email => 'Vous pouvez envoyer le lien par email.';

  @override
  String get sending => 'Envoi en cours..';

  @override
  String get sending_complete => 'Envoi terminé';

  @override
  String get failed => 'Échec';

  @override
  String get keys_not_found => 'Clés non trouvées';

  @override
  String sign_with_not_key(String data) {
    return '$data ne peut pas être signé car la clé privée n\'a pas été ajoutée.';
  }

  @override
  String get invalid_password => 'Mot de passe invalide';

  @override
  String get sign_email => 'Ajouter une signature numérique';

  @override
  String get sign_file_email => 'Signer le fichier et l\'email';

  @override
  String get data => 'données';

  @override
  String sign_data_with_not_key(String data) {
    return 'Ne signera pas les $data car vous n\'avez pas de clé privée PGP.';
  }

  @override
  String sign_mail_with_not_key(String data) {
    return 'Les $data ne seront pas signées car vous n\'avez pas de clé privée PGP.';
  }

  @override
  String get password_sign => 'Pour le chiffrement basé sur le mot de passe, la signature PGP n\'est pas prise en charge.';

  @override
  String get email_signed => 'L\'email sera signé en utilisant votre clé privée.';

  @override
  String get data_signed => 'Signera les données avec votre clé privée.';

  @override
  String data_not_signed(String data) {
    return 'Les $data ne seront pas signées.';
  }

  @override
  String get protected_public_link => 'Lien public protégé';

  @override
  String get send_public_link_to => 'Envoyer le lien public à';

  @override
  String get copy_password => 'Vous pouvez envoyer le lien par email. Le mot de passe doit être envoyé par un canal différent.\n\nVous pourrez récupérer le mot de passe quand nécessaire.';

  @override
  String get copy_encrypted_password => 'Vous pouvez envoyer le lien par email. Le mot de passe doit être envoyé par un canal différent.\n\nStockez le mot de passe quelque part. Vous ne pourrez pas le récupérer autrement.';

  @override
  String encrypted_sign_using_key(String user) {
    return 'Le fichier est chiffré en utilisant la clé publique PGP de $user. Vous pouvez envoyer le lien via un email chiffré signé numériquement.';
  }

  @override
  String get email_not_signed => 'L\'email ne sera pas signé.';

  @override
  String get two_factor_auth => 'Votre compte est protégé par\nune authentification à deux facteurs.\nVeuillez fournir le code PIN.';

  @override
  String get pin => 'PIN';

  @override
  String get verify_pin => 'Vérifier le pin';

  @override
  String get invalid_pin => 'PIN invalide';

  @override
  String get upload_file => 'Télécharger un fichier';

  @override
  String upload_files(String count) {
    return 'Télécharger $count fichiers';
  }

  @override
  String get login_to_continue => 'Se connecter pour continuer';

  @override
  String get confirm_exit => 'Êtes-vous sûr de vouloir quitter ?';

  @override
  String get exit => 'Quitter';

  @override
  String get error_required_pgp_key => 'Clé PGP requise';

  @override
  String get label_required_pgp_key => 'Clé PGP requise';

  @override
  String hint_upload_encrypt_ask(String name) {
    return 'Chiffrer \'$name\' ?';
  }

  @override
  String get btn_do_not_encrypt => 'Ne pas chiffrer';

  @override
  String get label_encryption_always_in_encryption_folder => 'Toujours dans le dossier Chiffré';

  @override
  String get label_encryption_always => 'Toujours';

  @override
  String get label_encryption_ask => 'Me demander';

  @override
  String get label_encryption_never => 'Jamais';

  @override
  String get label_encryption_enable_paranoid_encryption => 'Activer le chiffrement paranoïaque';

  @override
  String get btn_encryption_enable => 'Activer le chiffrement paranoïaque';

  @override
  String get label_encryption_mode => 'Chiffrer les fichiers téléchargés';

  @override
  String get label_save => 'Sauvegarder';

  @override
  String get label_encryption_password_for_pgp_key => 'Mot de passe requis pour la clé PGP';

  @override
  String get label_pgp_import_key => 'Importer les clés';

  @override
  String get hint_pgp_already_have_keys => 'Les clés qui sont déjà dans le système sont grisées.';

  @override
  String get hint_pgp_your_keys => 'Vos clés';

  @override
  String get hint_pgp_keys_will_be_import_to_contacts => 'Les clés seront importées dans les contacts';

  @override
  String get btn_pgp_import_selected_key => 'Importer les clés sélectionnées';

  @override
  String get label_pgp_contact_public_keys => 'Clés publiques externes';

  @override
  String error_pgp_required_key(String user) {
    return 'Aucune clé privée trouvée pour l\'utilisateur $user.';
  }

  @override
  String get label_share_with_teammates => 'Partager avec les coéquipiers';

  @override
  String get hint_pgp_share_warning => 'Vous allez partager votre clé privée PGP. La clé doit être gardée des tiers. Voulez-vous continuer ?';

  @override
  String get label_pgp_share_warning => 'Attention';

  @override
  String get hint_share_folder => 'Les fichiers chiffrés ne seront pas disponibles dans le dossier partagé.';

  @override
  String get input_who_cas_see => 'Qui peut voir';

  @override
  String get input_who_cas_edit => 'Qui peut modifier';

  @override
  String get btn_show_encrypt => 'Afficher';

  @override
  String get label_store_password_in_session => 'Stocker le mot de passe de la clé OpenPGP dans une session';

  @override
  String get btn_enable_backward_compatibility => 'Activer la compatibilité descendante';

  @override
  String get error_backward_compatibility_sharing_not_supported => 'Le partage de ce fichier n\'est pas pris en charge. Le fichier est chiffré en utilisant l\'ancien mode de chiffrement. Le fichier doit être téléchargé et chiffré en utilisant le mode de chiffrement moderne. Veuillez télécharger et télécharger à nouveau le fichier.';

  @override
  String get hint_backward_compatibility_aes_key => 'La clé AES sera utilisée uniquement pour déchiffrer les fichiers qui sont chiffrés en utilisant l\'ancien mode de chiffrement. Les nouveaux fichiers seront chiffrés en utilisant le mode de chiffrement moderne.';

  @override
  String get label_delete_folder => 'Supprimer le dossier';

  @override
  String get fido_error_invalid_key => 'Clé de sécurité invalide';

  @override
  String get tfa_label => 'Vérification à deux facteurs';

  @override
  String get tfa_hint_step => 'Cette étape supplémentaire est destinée à confirmer que c\'est vraiment vous qui essayez de vous connecter';

  @override
  String get fido_btn_use_key => 'Utiliser la clé de sécurité';

  @override
  String get fido_label_connect_your_key => 'Veuillez scanner votre clé de sécurité ou l\'insérer dans l\'appareil';

  @override
  String get fido_label_success => 'Succès';

  @override
  String get tfa_btn_other_options => 'Autres options';

  @override
  String get tfa_btn_use_backup_code => 'Utiliser le code de sauvegarde';

  @override
  String get tfa_btn_use_auth_app => 'Utiliser l\'application d\'authentification';

  @override
  String get tfa_btn_use_security_key => 'Utiliser votre clé de sécurité';

  @override
  String get tfa_label_hint_security_options => 'Options de sécurité disponibles';

  @override
  String get fido_label_touch_your_key => 'Touchez votre clé de sécurité';

  @override
  String get fido_hint_follow_the_instructions => 'Veuillez suivre les instructions dans la boîte de dialogue contextuelle';

  @override
  String get fido_error_title => 'Il y a eu un problème';

  @override
  String get fido_error_hint => 'Essayez d\'utiliser à nouveau votre clé de sécurité ou essayez une autre façon de vérifier que c\'est vous';

  @override
  String get fido_btn_try_again => 'Réessayer';

  @override
  String get tfa_input_hint_code_from_app => 'Spécifiez le code de vérification de l\'application d\'authentification';

  @override
  String get btn_login_back_to_login => 'Retour à la connexion';

  @override
  String get input_2fa_pin => 'Code de vérification';

  @override
  String get btn_verify_pin => 'Vérifier';

  @override
  String get error_invalid_pin => 'Code invalide';

  @override
  String get tfa_label_enter_backup_code => 'Entrez l\'un de vos codes de sauvegarde à 8 caractères';

  @override
  String get tfa_input_backup_code => 'Code de sauvegarde';

  @override
  String get tfa_label_trust_device => 'Vous êtes prêt';

  @override
  String tfa_check_box_trust_device(String daysCount) {
    return 'Ne plus demander sur cet appareil pendant $daysCount jours';
  }

  @override
  String get tfa_button_continue => 'Continuer';

  @override
  String get logger_label_show_debug_view => 'Afficher la vue de débogage';

  @override
  String get logger_btn_delete_all => 'Supprimer tout';

  @override
  String get logger_hint_delete_all_logs => 'Êtes-vous sûr de vouloir supprimer tous les journaux';

  @override
  String get logger_hint_delete_log => 'Êtes-vous sûr de vouloir supprimer le fichier';

  @override
  String get clear_cache_during_logout => 'Supprimer les données en cache et les clés';

  @override
  String get btn_encryption_personal_storage => 'Autoriser le chiffrement des fichiers dans le stockage personnel';

  @override
  String get hint_pgp_no_keys_to_import => 'Le texte ne contient aucune clé qui peut être importée.';

  @override
  String get label_encryption_module_not_exist => 'Le module de chiffrement\nn\'est pas disponible sur le backend';

  @override
  String get hint_pgp_external_private_keys => 'Les clés privées externes ne sont pas prises en charge et ne seront pas importées';

  @override
  String get label_leave_share => 'Quitter le partage';

  @override
  String get label_leave_share_of => 'Quitter le partage de ';

  @override
  String get label_share_history_title => 'Historique d\'activité du fichier partagé';

  @override
  String get hint_select_teammate => 'Sélectionner un coéquipier';

  @override
  String get label_no_share => 'Aucun partage pour le moment';

  @override
  String get label_show_history => 'Afficher l\'historique';

  @override
  String get clear_cache_during_login => 'Lors du changement d\'utilisateur, il est nécessaire de vider les données en cache et les clés de l\'utilisateur précédent.';

  @override
  String get settings_delete_account => 'Supprimer le compte';
}
