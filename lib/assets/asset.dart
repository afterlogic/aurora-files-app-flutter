class Asset {
  static final images = _Images();
  static final svg = _Svg();
}

class _Images {
  static const _path = 'lib/assets/images/';
  final imagePlaceholder = _path + 'image_placeholder.jpg';
  final useKey = _path + 'use_key.png';
}

class _Svg {
  static const _path = 'lib/assets/svg/';
  final iconFolder = _path + 'icon_folder.svg';
  final iconGroup16 = _path + 'icon_group_16.svg';
  final iconShareLeave = _path + 'icon_share_leave.svg';
  final iconSharedWithMe = _path + 'icon_shared_with_me.svg';
  final iconSharedWithMeBig = _path + 'icon_shared_with_me_big.svg';
  final iconStorageCorporate = _path + 'icon_storage_corporate.svg';
  final iconStorageEncrypted = _path + 'icon_storage_encrypted.svg';
  final iconStoragePersonal = _path + 'icon_storage_personal.svg';
  final iconStorageShared = _path + 'icon_storage_shared.svg';
  final iconTeam16 = _path + 'icon_team_16.svg';
  final insertLink = _path + 'insert_link.svg';
}
