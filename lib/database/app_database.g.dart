// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LocalFile extends DataClass implements Insertable<LocalFile> {
  final int localId;
  final String id;
  final String guid;
  final String type;
  final String path;
  final String fullPath;
  final String localPath;
  final String name;
  final int size;
  final bool isFolder;
  final bool isOpenable;
  final bool isLink;
  final String linkType;
  final String linkUrl;
  final int lastModified;
  final String contentType;
  final String oEmbedHtml;
  final bool published;
  final String owner;
  final String content;
  final String viewUrl;
  final String downloadUrl;
  final String thumbnailUrl;
  final String hash;
  final String extendedProps;
  final bool isExternal;
  final String initVector;
  final String linkPassword;
  final String encryptedDecryptionKey;
  LocalFile(
      {@required this.localId,
      @required this.id,
      this.guid,
      @required this.type,
      @required this.path,
      @required this.fullPath,
      @required this.localPath,
      @required this.name,
      @required this.size,
      @required this.isFolder,
      @required this.isOpenable,
      @required this.isLink,
      @required this.linkType,
      @required this.linkUrl,
      @required this.lastModified,
      @required this.contentType,
      @required this.oEmbedHtml,
      @required this.published,
      @required this.owner,
      @required this.content,
      @required this.viewUrl,
      @required this.downloadUrl,
      this.thumbnailUrl,
      @required this.hash,
      @required this.extendedProps,
      @required this.isExternal,
      this.initVector,
      this.linkPassword,
      this.encryptedDecryptionKey});
  factory LocalFile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return LocalFile(
      localId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']),
      guid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}guid']),
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type']),
      path: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}path']),
      fullPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}full_path']),
      localPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_path']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      size: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}size']),
      isFolder: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_folder']),
      isOpenable: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_openable']),
      isLink: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_link']),
      linkType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}link_type']),
      linkUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}link_url']),
      lastModified: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_modified']),
      contentType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content_type']),
      oEmbedHtml: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}o_embed_html']),
      published: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}published']),
      owner: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner']),
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content']),
      viewUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}view_url']),
      downloadUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}download_url']),
      thumbnailUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_url']),
      hash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hash']),
      extendedProps: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extended_props']),
      isExternal: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_external']),
      initVector: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}init_vector']),
      linkPassword: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}link_password']),
      encryptedDecryptionKey: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}encrypted_decryption_key']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<int>(localId);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || guid != null) {
      map['guid'] = Variable<String>(guid);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || fullPath != null) {
      map['full_path'] = Variable<String>(fullPath);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || isFolder != null) {
      map['is_folder'] = Variable<bool>(isFolder);
    }
    if (!nullToAbsent || isOpenable != null) {
      map['is_openable'] = Variable<bool>(isOpenable);
    }
    if (!nullToAbsent || isLink != null) {
      map['is_link'] = Variable<bool>(isLink);
    }
    if (!nullToAbsent || linkType != null) {
      map['link_type'] = Variable<String>(linkType);
    }
    if (!nullToAbsent || linkUrl != null) {
      map['link_url'] = Variable<String>(linkUrl);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<int>(lastModified);
    }
    if (!nullToAbsent || contentType != null) {
      map['content_type'] = Variable<String>(contentType);
    }
    if (!nullToAbsent || oEmbedHtml != null) {
      map['o_embed_html'] = Variable<String>(oEmbedHtml);
    }
    if (!nullToAbsent || published != null) {
      map['published'] = Variable<bool>(published);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String>(owner);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || viewUrl != null) {
      map['view_url'] = Variable<String>(viewUrl);
    }
    if (!nullToAbsent || downloadUrl != null) {
      map['download_url'] = Variable<String>(downloadUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    if (!nullToAbsent || extendedProps != null) {
      map['extended_props'] = Variable<String>(extendedProps);
    }
    if (!nullToAbsent || isExternal != null) {
      map['is_external'] = Variable<bool>(isExternal);
    }
    if (!nullToAbsent || initVector != null) {
      map['init_vector'] = Variable<String>(initVector);
    }
    if (!nullToAbsent || linkPassword != null) {
      map['link_password'] = Variable<String>(linkPassword);
    }
    if (!nullToAbsent || encryptedDecryptionKey != null) {
      map['encrypted_decryption_key'] =
          Variable<String>(encryptedDecryptionKey);
    }
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      guid: guid == null && nullToAbsent ? const Value.absent() : Value(guid),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      fullPath: fullPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fullPath),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      isFolder: isFolder == null && nullToAbsent
          ? const Value.absent()
          : Value(isFolder),
      isOpenable: isOpenable == null && nullToAbsent
          ? const Value.absent()
          : Value(isOpenable),
      isLink:
          isLink == null && nullToAbsent ? const Value.absent() : Value(isLink),
      linkType: linkType == null && nullToAbsent
          ? const Value.absent()
          : Value(linkType),
      linkUrl: linkUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(linkUrl),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      contentType: contentType == null && nullToAbsent
          ? const Value.absent()
          : Value(contentType),
      oEmbedHtml: oEmbedHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(oEmbedHtml),
      published: published == null && nullToAbsent
          ? const Value.absent()
          : Value(published),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      viewUrl: viewUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(viewUrl),
      downloadUrl: downloadUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      extendedProps: extendedProps == null && nullToAbsent
          ? const Value.absent()
          : Value(extendedProps),
      isExternal: isExternal == null && nullToAbsent
          ? const Value.absent()
          : Value(isExternal),
      initVector: initVector == null && nullToAbsent
          ? const Value.absent()
          : Value(initVector),
      linkPassword: linkPassword == null && nullToAbsent
          ? const Value.absent()
          : Value(linkPassword),
      encryptedDecryptionKey: encryptedDecryptionKey == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedDecryptionKey),
    );
  }

  factory LocalFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalFile(
      localId: serializer.fromJson<int>(json['localId']),
      id: serializer.fromJson<String>(json['id']),
      guid: serializer.fromJson<String>(json['guid']),
      type: serializer.fromJson<String>(json['type']),
      path: serializer.fromJson<String>(json['path']),
      fullPath: serializer.fromJson<String>(json['fullPath']),
      localPath: serializer.fromJson<String>(json['localPath']),
      name: serializer.fromJson<String>(json['name']),
      size: serializer.fromJson<int>(json['size']),
      isFolder: serializer.fromJson<bool>(json['isFolder']),
      isOpenable: serializer.fromJson<bool>(json['isOpenable']),
      isLink: serializer.fromJson<bool>(json['isLink']),
      linkType: serializer.fromJson<String>(json['linkType']),
      linkUrl: serializer.fromJson<String>(json['linkUrl']),
      lastModified: serializer.fromJson<int>(json['lastModified']),
      contentType: serializer.fromJson<String>(json['contentType']),
      oEmbedHtml: serializer.fromJson<String>(json['oEmbedHtml']),
      published: serializer.fromJson<bool>(json['published']),
      owner: serializer.fromJson<String>(json['owner']),
      content: serializer.fromJson<String>(json['content']),
      viewUrl: serializer.fromJson<String>(json['viewUrl']),
      downloadUrl: serializer.fromJson<String>(json['downloadUrl']),
      thumbnailUrl: serializer.fromJson<String>(json['thumbnailUrl']),
      hash: serializer.fromJson<String>(json['hash']),
      extendedProps: serializer.fromJson<String>(json['extendedProps']),
      isExternal: serializer.fromJson<bool>(json['isExternal']),
      initVector: serializer.fromJson<String>(json['initVector']),
      linkPassword: serializer.fromJson<String>(json['linkPassword']),
      encryptedDecryptionKey:
          serializer.fromJson<String>(json['encryptedDecryptionKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'id': serializer.toJson<String>(id),
      'guid': serializer.toJson<String>(guid),
      'type': serializer.toJson<String>(type),
      'path': serializer.toJson<String>(path),
      'fullPath': serializer.toJson<String>(fullPath),
      'localPath': serializer.toJson<String>(localPath),
      'name': serializer.toJson<String>(name),
      'size': serializer.toJson<int>(size),
      'isFolder': serializer.toJson<bool>(isFolder),
      'isOpenable': serializer.toJson<bool>(isOpenable),
      'isLink': serializer.toJson<bool>(isLink),
      'linkType': serializer.toJson<String>(linkType),
      'linkUrl': serializer.toJson<String>(linkUrl),
      'lastModified': serializer.toJson<int>(lastModified),
      'contentType': serializer.toJson<String>(contentType),
      'oEmbedHtml': serializer.toJson<String>(oEmbedHtml),
      'published': serializer.toJson<bool>(published),
      'owner': serializer.toJson<String>(owner),
      'content': serializer.toJson<String>(content),
      'viewUrl': serializer.toJson<String>(viewUrl),
      'downloadUrl': serializer.toJson<String>(downloadUrl),
      'thumbnailUrl': serializer.toJson<String>(thumbnailUrl),
      'hash': serializer.toJson<String>(hash),
      'extendedProps': serializer.toJson<String>(extendedProps),
      'isExternal': serializer.toJson<bool>(isExternal),
      'initVector': serializer.toJson<String>(initVector),
      'linkPassword': serializer.toJson<String>(linkPassword),
      'encryptedDecryptionKey':
          serializer.toJson<String>(encryptedDecryptionKey),
    };
  }

  LocalFile copyWith(
          {int localId,
          String id,
          String guid,
          String type,
          String path,
          String fullPath,
          String localPath,
          String name,
          int size,
          bool isFolder,
          bool isOpenable,
          bool isLink,
          String linkType,
          String linkUrl,
          int lastModified,
          String contentType,
          String oEmbedHtml,
          bool published,
          String owner,
          String content,
          String viewUrl,
          String downloadUrl,
          String thumbnailUrl,
          String hash,
          String extendedProps,
          bool isExternal,
          String initVector,
          String linkPassword,
          String encryptedDecryptionKey}) =>
      LocalFile(
        localId: localId ?? this.localId,
        id: id ?? this.id,
        guid: guid ?? this.guid,
        type: type ?? this.type,
        path: path ?? this.path,
        fullPath: fullPath ?? this.fullPath,
        localPath: localPath ?? this.localPath,
        name: name ?? this.name,
        size: size ?? this.size,
        isFolder: isFolder ?? this.isFolder,
        isOpenable: isOpenable ?? this.isOpenable,
        isLink: isLink ?? this.isLink,
        linkType: linkType ?? this.linkType,
        linkUrl: linkUrl ?? this.linkUrl,
        lastModified: lastModified ?? this.lastModified,
        contentType: contentType ?? this.contentType,
        oEmbedHtml: oEmbedHtml ?? this.oEmbedHtml,
        published: published ?? this.published,
        owner: owner ?? this.owner,
        content: content ?? this.content,
        viewUrl: viewUrl ?? this.viewUrl,
        downloadUrl: downloadUrl ?? this.downloadUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        hash: hash ?? this.hash,
        extendedProps: extendedProps ?? this.extendedProps,
        isExternal: isExternal ?? this.isExternal,
        initVector: initVector ?? this.initVector,
        linkPassword: linkPassword ?? this.linkPassword,
        encryptedDecryptionKey:
            encryptedDecryptionKey ?? this.encryptedDecryptionKey,
      );
  @override
  String toString() {
    return (StringBuffer('LocalFile(')
          ..write('localId: $localId, ')
          ..write('id: $id, ')
          ..write('guid: $guid, ')
          ..write('type: $type, ')
          ..write('path: $path, ')
          ..write('fullPath: $fullPath, ')
          ..write('localPath: $localPath, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('isFolder: $isFolder, ')
          ..write('isOpenable: $isOpenable, ')
          ..write('isLink: $isLink, ')
          ..write('linkType: $linkType, ')
          ..write('linkUrl: $linkUrl, ')
          ..write('lastModified: $lastModified, ')
          ..write('contentType: $contentType, ')
          ..write('oEmbedHtml: $oEmbedHtml, ')
          ..write('published: $published, ')
          ..write('owner: $owner, ')
          ..write('content: $content, ')
          ..write('viewUrl: $viewUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('hash: $hash, ')
          ..write('extendedProps: $extendedProps, ')
          ..write('isExternal: $isExternal, ')
          ..write('initVector: $initVector, ')
          ..write('linkPassword: $linkPassword, ')
          ..write('encryptedDecryptionKey: $encryptedDecryptionKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        localId,
        id,
        guid,
        type,
        path,
        fullPath,
        localPath,
        name,
        size,
        isFolder,
        isOpenable,
        isLink,
        linkType,
        linkUrl,
        lastModified,
        contentType,
        oEmbedHtml,
        published,
        owner,
        content,
        viewUrl,
        downloadUrl,
        thumbnailUrl,
        hash,
        extendedProps,
        isExternal,
        initVector,
        linkPassword,
        encryptedDecryptionKey
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFile &&
          other.localId == this.localId &&
          other.id == this.id &&
          other.guid == this.guid &&
          other.type == this.type &&
          other.path == this.path &&
          other.fullPath == this.fullPath &&
          other.localPath == this.localPath &&
          other.name == this.name &&
          other.size == this.size &&
          other.isFolder == this.isFolder &&
          other.isOpenable == this.isOpenable &&
          other.isLink == this.isLink &&
          other.linkType == this.linkType &&
          other.linkUrl == this.linkUrl &&
          other.lastModified == this.lastModified &&
          other.contentType == this.contentType &&
          other.oEmbedHtml == this.oEmbedHtml &&
          other.published == this.published &&
          other.owner == this.owner &&
          other.content == this.content &&
          other.viewUrl == this.viewUrl &&
          other.downloadUrl == this.downloadUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.hash == this.hash &&
          other.extendedProps == this.extendedProps &&
          other.isExternal == this.isExternal &&
          other.initVector == this.initVector &&
          other.linkPassword == this.linkPassword &&
          other.encryptedDecryptionKey == this.encryptedDecryptionKey);
}

class FilesCompanion extends UpdateCompanion<LocalFile> {
  final Value<int> localId;
  final Value<String> id;
  final Value<String> guid;
  final Value<String> type;
  final Value<String> path;
  final Value<String> fullPath;
  final Value<String> localPath;
  final Value<String> name;
  final Value<int> size;
  final Value<bool> isFolder;
  final Value<bool> isOpenable;
  final Value<bool> isLink;
  final Value<String> linkType;
  final Value<String> linkUrl;
  final Value<int> lastModified;
  final Value<String> contentType;
  final Value<String> oEmbedHtml;
  final Value<bool> published;
  final Value<String> owner;
  final Value<String> content;
  final Value<String> viewUrl;
  final Value<String> downloadUrl;
  final Value<String> thumbnailUrl;
  final Value<String> hash;
  final Value<String> extendedProps;
  final Value<bool> isExternal;
  final Value<String> initVector;
  final Value<String> linkPassword;
  final Value<String> encryptedDecryptionKey;
  const FilesCompanion({
    this.localId = const Value.absent(),
    this.id = const Value.absent(),
    this.guid = const Value.absent(),
    this.type = const Value.absent(),
    this.path = const Value.absent(),
    this.fullPath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.name = const Value.absent(),
    this.size = const Value.absent(),
    this.isFolder = const Value.absent(),
    this.isOpenable = const Value.absent(),
    this.isLink = const Value.absent(),
    this.linkType = const Value.absent(),
    this.linkUrl = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.contentType = const Value.absent(),
    this.oEmbedHtml = const Value.absent(),
    this.published = const Value.absent(),
    this.owner = const Value.absent(),
    this.content = const Value.absent(),
    this.viewUrl = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.hash = const Value.absent(),
    this.extendedProps = const Value.absent(),
    this.isExternal = const Value.absent(),
    this.initVector = const Value.absent(),
    this.linkPassword = const Value.absent(),
    this.encryptedDecryptionKey = const Value.absent(),
  });
  FilesCompanion.insert({
    this.localId = const Value.absent(),
    @required String id,
    this.guid = const Value.absent(),
    @required String type,
    @required String path,
    @required String fullPath,
    @required String localPath,
    @required String name,
    @required int size,
    @required bool isFolder,
    @required bool isOpenable,
    @required bool isLink,
    @required String linkType,
    @required String linkUrl,
    @required int lastModified,
    @required String contentType,
    @required String oEmbedHtml,
    @required bool published,
    @required String owner,
    @required String content,
    @required String viewUrl,
    @required String downloadUrl,
    this.thumbnailUrl = const Value.absent(),
    @required String hash,
    @required String extendedProps,
    @required bool isExternal,
    this.initVector = const Value.absent(),
    this.linkPassword = const Value.absent(),
    this.encryptedDecryptionKey = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        path = Value(path),
        fullPath = Value(fullPath),
        localPath = Value(localPath),
        name = Value(name),
        size = Value(size),
        isFolder = Value(isFolder),
        isOpenable = Value(isOpenable),
        isLink = Value(isLink),
        linkType = Value(linkType),
        linkUrl = Value(linkUrl),
        lastModified = Value(lastModified),
        contentType = Value(contentType),
        oEmbedHtml = Value(oEmbedHtml),
        published = Value(published),
        owner = Value(owner),
        content = Value(content),
        viewUrl = Value(viewUrl),
        downloadUrl = Value(downloadUrl),
        hash = Value(hash),
        extendedProps = Value(extendedProps),
        isExternal = Value(isExternal);
  static Insertable<LocalFile> custom({
    Expression<int> localId,
    Expression<String> id,
    Expression<String> guid,
    Expression<String> type,
    Expression<String> path,
    Expression<String> fullPath,
    Expression<String> localPath,
    Expression<String> name,
    Expression<int> size,
    Expression<bool> isFolder,
    Expression<bool> isOpenable,
    Expression<bool> isLink,
    Expression<String> linkType,
    Expression<String> linkUrl,
    Expression<int> lastModified,
    Expression<String> contentType,
    Expression<String> oEmbedHtml,
    Expression<bool> published,
    Expression<String> owner,
    Expression<String> content,
    Expression<String> viewUrl,
    Expression<String> downloadUrl,
    Expression<String> thumbnailUrl,
    Expression<String> hash,
    Expression<String> extendedProps,
    Expression<bool> isExternal,
    Expression<String> initVector,
    Expression<String> linkPassword,
    Expression<String> encryptedDecryptionKey,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (id != null) 'id': id,
      if (guid != null) 'guid': guid,
      if (type != null) 'type': type,
      if (path != null) 'path': path,
      if (fullPath != null) 'full_path': fullPath,
      if (localPath != null) 'local_path': localPath,
      if (name != null) 'name': name,
      if (size != null) 'size': size,
      if (isFolder != null) 'is_folder': isFolder,
      if (isOpenable != null) 'is_openable': isOpenable,
      if (isLink != null) 'is_link': isLink,
      if (linkType != null) 'link_type': linkType,
      if (linkUrl != null) 'link_url': linkUrl,
      if (lastModified != null) 'last_modified': lastModified,
      if (contentType != null) 'content_type': contentType,
      if (oEmbedHtml != null) 'o_embed_html': oEmbedHtml,
      if (published != null) 'published': published,
      if (owner != null) 'owner': owner,
      if (content != null) 'content': content,
      if (viewUrl != null) 'view_url': viewUrl,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (hash != null) 'hash': hash,
      if (extendedProps != null) 'extended_props': extendedProps,
      if (isExternal != null) 'is_external': isExternal,
      if (initVector != null) 'init_vector': initVector,
      if (linkPassword != null) 'link_password': linkPassword,
      if (encryptedDecryptionKey != null)
        'encrypted_decryption_key': encryptedDecryptionKey,
    });
  }

  FilesCompanion copyWith(
      {Value<int> localId,
      Value<String> id,
      Value<String> guid,
      Value<String> type,
      Value<String> path,
      Value<String> fullPath,
      Value<String> localPath,
      Value<String> name,
      Value<int> size,
      Value<bool> isFolder,
      Value<bool> isOpenable,
      Value<bool> isLink,
      Value<String> linkType,
      Value<String> linkUrl,
      Value<int> lastModified,
      Value<String> contentType,
      Value<String> oEmbedHtml,
      Value<bool> published,
      Value<String> owner,
      Value<String> content,
      Value<String> viewUrl,
      Value<String> downloadUrl,
      Value<String> thumbnailUrl,
      Value<String> hash,
      Value<String> extendedProps,
      Value<bool> isExternal,
      Value<String> initVector,
      Value<String> linkPassword,
      Value<String> encryptedDecryptionKey}) {
    return FilesCompanion(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      guid: guid ?? this.guid,
      type: type ?? this.type,
      path: path ?? this.path,
      fullPath: fullPath ?? this.fullPath,
      localPath: localPath ?? this.localPath,
      name: name ?? this.name,
      size: size ?? this.size,
      isFolder: isFolder ?? this.isFolder,
      isOpenable: isOpenable ?? this.isOpenable,
      isLink: isLink ?? this.isLink,
      linkType: linkType ?? this.linkType,
      linkUrl: linkUrl ?? this.linkUrl,
      lastModified: lastModified ?? this.lastModified,
      contentType: contentType ?? this.contentType,
      oEmbedHtml: oEmbedHtml ?? this.oEmbedHtml,
      published: published ?? this.published,
      owner: owner ?? this.owner,
      content: content ?? this.content,
      viewUrl: viewUrl ?? this.viewUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      hash: hash ?? this.hash,
      extendedProps: extendedProps ?? this.extendedProps,
      isExternal: isExternal ?? this.isExternal,
      initVector: initVector ?? this.initVector,
      linkPassword: linkPassword ?? this.linkPassword,
      encryptedDecryptionKey:
          encryptedDecryptionKey ?? this.encryptedDecryptionKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (fullPath.present) {
      map['full_path'] = Variable<String>(fullPath.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (isFolder.present) {
      map['is_folder'] = Variable<bool>(isFolder.value);
    }
    if (isOpenable.present) {
      map['is_openable'] = Variable<bool>(isOpenable.value);
    }
    if (isLink.present) {
      map['is_link'] = Variable<bool>(isLink.value);
    }
    if (linkType.present) {
      map['link_type'] = Variable<String>(linkType.value);
    }
    if (linkUrl.present) {
      map['link_url'] = Variable<String>(linkUrl.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<int>(lastModified.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (oEmbedHtml.present) {
      map['o_embed_html'] = Variable<String>(oEmbedHtml.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (viewUrl.present) {
      map['view_url'] = Variable<String>(viewUrl.value);
    }
    if (downloadUrl.present) {
      map['download_url'] = Variable<String>(downloadUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (extendedProps.present) {
      map['extended_props'] = Variable<String>(extendedProps.value);
    }
    if (isExternal.present) {
      map['is_external'] = Variable<bool>(isExternal.value);
    }
    if (initVector.present) {
      map['init_vector'] = Variable<String>(initVector.value);
    }
    if (linkPassword.present) {
      map['link_password'] = Variable<String>(linkPassword.value);
    }
    if (encryptedDecryptionKey.present) {
      map['encrypted_decryption_key'] =
          Variable<String>(encryptedDecryptionKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilesCompanion(')
          ..write('localId: $localId, ')
          ..write('id: $id, ')
          ..write('guid: $guid, ')
          ..write('type: $type, ')
          ..write('path: $path, ')
          ..write('fullPath: $fullPath, ')
          ..write('localPath: $localPath, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('isFolder: $isFolder, ')
          ..write('isOpenable: $isOpenable, ')
          ..write('isLink: $isLink, ')
          ..write('linkType: $linkType, ')
          ..write('linkUrl: $linkUrl, ')
          ..write('lastModified: $lastModified, ')
          ..write('contentType: $contentType, ')
          ..write('oEmbedHtml: $oEmbedHtml, ')
          ..write('published: $published, ')
          ..write('owner: $owner, ')
          ..write('content: $content, ')
          ..write('viewUrl: $viewUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('hash: $hash, ')
          ..write('extendedProps: $extendedProps, ')
          ..write('isExternal: $isExternal, ')
          ..write('initVector: $initVector, ')
          ..write('linkPassword: $linkPassword, ')
          ..write('encryptedDecryptionKey: $encryptedDecryptionKey')
          ..write(')'))
        .toString();
  }
}

class $FilesTable extends Files with TableInfo<$FilesTable, LocalFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $FilesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedColumn<int> _localId;
  @override
  GeneratedColumn<int> get localId =>
      _localId ??= GeneratedColumn<int>('local_id', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<String> _id;
  @override
  GeneratedColumn<String> get id =>
      _id ??= GeneratedColumn<String>('id', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _guidMeta = const VerificationMeta('guid');
  GeneratedColumn<String> _guid;
  @override
  GeneratedColumn<String> get guid =>
      _guid ??= GeneratedColumn<String>('guid', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedColumn<String> _type;
  @override
  GeneratedColumn<String> get type =>
      _type ??= GeneratedColumn<String>('type', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedColumn<String> _path;
  @override
  GeneratedColumn<String> get path =>
      _path ??= GeneratedColumn<String>('path', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fullPathMeta = const VerificationMeta('fullPath');
  GeneratedColumn<String> _fullPath;
  @override
  GeneratedColumn<String> get fullPath =>
      _fullPath ??= GeneratedColumn<String>('full_path', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _localPathMeta = const VerificationMeta('localPath');
  GeneratedColumn<String> _localPath;
  @override
  GeneratedColumn<String> get localPath =>
      _localPath ??= GeneratedColumn<String>('local_path', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name =>
      _name ??= GeneratedColumn<String>('name', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _sizeMeta = const VerificationMeta('size');
  GeneratedColumn<int> _size;
  @override
  GeneratedColumn<int> get size =>
      _size ??= GeneratedColumn<int>('size', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _isFolderMeta = const VerificationMeta('isFolder');
  GeneratedColumn<bool> _isFolder;
  @override
  GeneratedColumn<bool> get isFolder =>
      _isFolder ??= GeneratedColumn<bool>('is_folder', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (is_folder IN (0, 1))');
  final VerificationMeta _isOpenableMeta = const VerificationMeta('isOpenable');
  GeneratedColumn<bool> _isOpenable;
  @override
  GeneratedColumn<bool> get isOpenable =>
      _isOpenable ??= GeneratedColumn<bool>('is_openable', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (is_openable IN (0, 1))');
  final VerificationMeta _isLinkMeta = const VerificationMeta('isLink');
  GeneratedColumn<bool> _isLink;
  @override
  GeneratedColumn<bool> get isLink =>
      _isLink ??= GeneratedColumn<bool>('is_link', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (is_link IN (0, 1))');
  final VerificationMeta _linkTypeMeta = const VerificationMeta('linkType');
  GeneratedColumn<String> _linkType;
  @override
  GeneratedColumn<String> get linkType =>
      _linkType ??= GeneratedColumn<String>('link_type', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _linkUrlMeta = const VerificationMeta('linkUrl');
  GeneratedColumn<String> _linkUrl;
  @override
  GeneratedColumn<String> get linkUrl =>
      _linkUrl ??= GeneratedColumn<String>('link_url', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  GeneratedColumn<int> _lastModified;
  @override
  GeneratedColumn<int> get lastModified => _lastModified ??=
      GeneratedColumn<int>('last_modified', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  GeneratedColumn<String> _contentType;
  @override
  GeneratedColumn<String> get contentType => _contentType ??=
      GeneratedColumn<String>('content_type', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _oEmbedHtmlMeta = const VerificationMeta('oEmbedHtml');
  GeneratedColumn<String> _oEmbedHtml;
  @override
  GeneratedColumn<String> get oEmbedHtml => _oEmbedHtml ??=
      GeneratedColumn<String>('o_embed_html', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _publishedMeta = const VerificationMeta('published');
  GeneratedColumn<bool> _published;
  @override
  GeneratedColumn<bool> get published =>
      _published ??= GeneratedColumn<bool>('published', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (published IN (0, 1))');
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  GeneratedColumn<String> _owner;
  @override
  GeneratedColumn<String> get owner =>
      _owner ??= GeneratedColumn<String>('owner', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedColumn<String> _content;
  @override
  GeneratedColumn<String> get content =>
      _content ??= GeneratedColumn<String>('content', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _viewUrlMeta = const VerificationMeta('viewUrl');
  GeneratedColumn<String> _viewUrl;
  @override
  GeneratedColumn<String> get viewUrl =>
      _viewUrl ??= GeneratedColumn<String>('view_url', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _downloadUrlMeta =
      const VerificationMeta('downloadUrl');
  GeneratedColumn<String> _downloadUrl;
  @override
  GeneratedColumn<String> get downloadUrl => _downloadUrl ??=
      GeneratedColumn<String>('download_url', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  GeneratedColumn<String> _thumbnailUrl;
  @override
  GeneratedColumn<String> get thumbnailUrl => _thumbnailUrl ??=
      GeneratedColumn<String>('thumbnail_url', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _hashMeta = const VerificationMeta('hash');
  GeneratedColumn<String> _hash;
  @override
  GeneratedColumn<String> get hash =>
      _hash ??= GeneratedColumn<String>('hash', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _extendedPropsMeta =
      const VerificationMeta('extendedProps');
  GeneratedColumn<String> _extendedProps;
  @override
  GeneratedColumn<String> get extendedProps => _extendedProps ??=
      GeneratedColumn<String>('extended_props', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isExternalMeta = const VerificationMeta('isExternal');
  GeneratedColumn<bool> _isExternal;
  @override
  GeneratedColumn<bool> get isExternal =>
      _isExternal ??= GeneratedColumn<bool>('is_external', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (is_external IN (0, 1))');
  final VerificationMeta _initVectorMeta = const VerificationMeta('initVector');
  GeneratedColumn<String> _initVector;
  @override
  GeneratedColumn<String> get initVector =>
      _initVector ??= GeneratedColumn<String>('init_vector', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _linkPasswordMeta =
      const VerificationMeta('linkPassword');
  GeneratedColumn<String> _linkPassword;
  @override
  GeneratedColumn<String> get linkPassword => _linkPassword ??=
      GeneratedColumn<String>('link_password', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _encryptedDecryptionKeyMeta =
      const VerificationMeta('encryptedDecryptionKey');
  GeneratedColumn<String> _encryptedDecryptionKey;
  @override
  GeneratedColumn<String> get encryptedDecryptionKey =>
      _encryptedDecryptionKey ??= GeneratedColumn<String>(
          'encrypted_decryption_key', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        id,
        guid,
        type,
        path,
        fullPath,
        localPath,
        name,
        size,
        isFolder,
        isOpenable,
        isLink,
        linkType,
        linkUrl,
        lastModified,
        contentType,
        oEmbedHtml,
        published,
        owner,
        content,
        viewUrl,
        downloadUrl,
        thumbnailUrl,
        hash,
        extendedProps,
        isExternal,
        initVector,
        linkPassword,
        encryptedDecryptionKey
      ];
  @override
  String get aliasedName => _alias ?? 'files';
  @override
  String get actualTableName => 'files';
  @override
  VerificationContext validateIntegrity(Insertable<LocalFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id'], _localIdMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid'], _guidMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path'], _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('full_path')) {
      context.handle(_fullPathMeta,
          fullPath.isAcceptableOrUnknown(data['full_path'], _fullPathMeta));
    } else if (isInserting) {
      context.missing(_fullPathMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path'], _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size'], _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('is_folder')) {
      context.handle(_isFolderMeta,
          isFolder.isAcceptableOrUnknown(data['is_folder'], _isFolderMeta));
    } else if (isInserting) {
      context.missing(_isFolderMeta);
    }
    if (data.containsKey('is_openable')) {
      context.handle(
          _isOpenableMeta,
          isOpenable.isAcceptableOrUnknown(
              data['is_openable'], _isOpenableMeta));
    } else if (isInserting) {
      context.missing(_isOpenableMeta);
    }
    if (data.containsKey('is_link')) {
      context.handle(_isLinkMeta,
          isLink.isAcceptableOrUnknown(data['is_link'], _isLinkMeta));
    } else if (isInserting) {
      context.missing(_isLinkMeta);
    }
    if (data.containsKey('link_type')) {
      context.handle(_linkTypeMeta,
          linkType.isAcceptableOrUnknown(data['link_type'], _linkTypeMeta));
    } else if (isInserting) {
      context.missing(_linkTypeMeta);
    }
    if (data.containsKey('link_url')) {
      context.handle(_linkUrlMeta,
          linkUrl.isAcceptableOrUnknown(data['link_url'], _linkUrlMeta));
    } else if (isInserting) {
      context.missing(_linkUrlMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified'], _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type'], _contentTypeMeta));
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('o_embed_html')) {
      context.handle(
          _oEmbedHtmlMeta,
          oEmbedHtml.isAcceptableOrUnknown(
              data['o_embed_html'], _oEmbedHtmlMeta));
    } else if (isInserting) {
      context.missing(_oEmbedHtmlMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published'], _publishedMeta));
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner'], _ownerMeta));
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('view_url')) {
      context.handle(_viewUrlMeta,
          viewUrl.isAcceptableOrUnknown(data['view_url'], _viewUrlMeta));
    } else if (isInserting) {
      context.missing(_viewUrlMeta);
    }
    if (data.containsKey('download_url')) {
      context.handle(
          _downloadUrlMeta,
          downloadUrl.isAcceptableOrUnknown(
              data['download_url'], _downloadUrlMeta));
    } else if (isInserting) {
      context.missing(_downloadUrlMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url'], _thumbnailUrlMeta));
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash'], _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('extended_props')) {
      context.handle(
          _extendedPropsMeta,
          extendedProps.isAcceptableOrUnknown(
              data['extended_props'], _extendedPropsMeta));
    } else if (isInserting) {
      context.missing(_extendedPropsMeta);
    }
    if (data.containsKey('is_external')) {
      context.handle(
          _isExternalMeta,
          isExternal.isAcceptableOrUnknown(
              data['is_external'], _isExternalMeta));
    } else if (isInserting) {
      context.missing(_isExternalMeta);
    }
    if (data.containsKey('init_vector')) {
      context.handle(
          _initVectorMeta,
          initVector.isAcceptableOrUnknown(
              data['init_vector'], _initVectorMeta));
    }
    if (data.containsKey('link_password')) {
      context.handle(
          _linkPasswordMeta,
          linkPassword.isAcceptableOrUnknown(
              data['link_password'], _linkPasswordMeta));
    }
    if (data.containsKey('encrypted_decryption_key')) {
      context.handle(
          _encryptedDecryptionKeyMeta,
          encryptedDecryptionKey.isAcceptableOrUnknown(
              data['encrypted_decryption_key'], _encryptedDecryptionKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalFile map(Map<String, dynamic> data, {String tablePrefix}) {
    return LocalFile.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }
}

class LocalPgpKey extends DataClass implements Insertable<LocalPgpKey> {
  final int id;
  final String email;
  final String key;
  final bool isPrivate;
  final int length;
  final String name;
  LocalPgpKey(
      {@required this.id,
      @required this.email,
      @required this.key,
      @required this.isPrivate,
      this.length,
      @required this.name});
  factory LocalPgpKey.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return LocalPgpKey(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key']),
      isPrivate: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_private']),
      length: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}length']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || key != null) {
      map['key'] = Variable<String>(key);
    }
    if (!nullToAbsent || isPrivate != null) {
      map['is_private'] = Variable<bool>(isPrivate);
    }
    if (!nullToAbsent || length != null) {
      map['length'] = Variable<int>(length);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  PgpKeyCompanion toCompanion(bool nullToAbsent) {
    return PgpKeyCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
      isPrivate: isPrivate == null && nullToAbsent
          ? const Value.absent()
          : Value(isPrivate),
      length:
          length == null && nullToAbsent ? const Value.absent() : Value(length),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory LocalPgpKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalPgpKey(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      key: serializer.fromJson<String>(json['key']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      length: serializer.fromJson<int>(json['length']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'key': serializer.toJson<String>(key),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'length': serializer.toJson<int>(length),
      'name': serializer.toJson<String>(name),
    };
  }

  LocalPgpKey copyWith(
          {int id,
          String email,
          String key,
          bool isPrivate,
          int length,
          String name}) =>
      LocalPgpKey(
        id: id ?? this.id,
        email: email ?? this.email,
        key: key ?? this.key,
        isPrivate: isPrivate ?? this.isPrivate,
        length: length ?? this.length,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('LocalPgpKey(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('key: $key, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('length: $length, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, key, isPrivate, length, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPgpKey &&
          other.id == this.id &&
          other.email == this.email &&
          other.key == this.key &&
          other.isPrivate == this.isPrivate &&
          other.length == this.length &&
          other.name == this.name);
}

class PgpKeyCompanion extends UpdateCompanion<LocalPgpKey> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> key;
  final Value<bool> isPrivate;
  final Value<int> length;
  final Value<String> name;
  const PgpKeyCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.key = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.length = const Value.absent(),
    this.name = const Value.absent(),
  });
  PgpKeyCompanion.insert({
    this.id = const Value.absent(),
    @required String email,
    @required String key,
    @required bool isPrivate,
    this.length = const Value.absent(),
    @required String name,
  })  : email = Value(email),
        key = Value(key),
        isPrivate = Value(isPrivate),
        name = Value(name);
  static Insertable<LocalPgpKey> custom({
    Expression<int> id,
    Expression<String> email,
    Expression<String> key,
    Expression<bool> isPrivate,
    Expression<int> length,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (key != null) 'key': key,
      if (isPrivate != null) 'is_private': isPrivate,
      if (length != null) 'length': length,
      if (name != null) 'name': name,
    });
  }

  PgpKeyCompanion copyWith(
      {Value<int> id,
      Value<String> email,
      Value<String> key,
      Value<bool> isPrivate,
      Value<int> length,
      Value<String> name}) {
    return PgpKeyCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      key: key ?? this.key,
      isPrivate: isPrivate ?? this.isPrivate,
      length: length ?? this.length,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (length.present) {
      map['length'] = Variable<int>(length.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PgpKeyCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('key: $key, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('length: $length, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PgpKeyTable extends PgpKey with TableInfo<$PgpKeyTable, LocalPgpKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $PgpKeyTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedColumn<String> _email;
  @override
  GeneratedColumn<String> get email =>
      _email ??= GeneratedColumn<String>('email', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  GeneratedColumn<String> _key;
  @override
  GeneratedColumn<String> get key =>
      _key ??= GeneratedColumn<String>('key', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isPrivateMeta = const VerificationMeta('isPrivate');
  GeneratedColumn<bool> _isPrivate;
  @override
  GeneratedColumn<bool> get isPrivate =>
      _isPrivate ??= GeneratedColumn<bool>('is_private', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: true,
          defaultConstraints: 'CHECK (is_private IN (0, 1))');
  final VerificationMeta _lengthMeta = const VerificationMeta('length');
  GeneratedColumn<int> _length;
  @override
  GeneratedColumn<int> get length =>
      _length ??= GeneratedColumn<int>('length', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name =>
      _name ??= GeneratedColumn<String>('name', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, key, isPrivate, length, name];
  @override
  String get aliasedName => _alias ?? 'pgp_key';
  @override
  String get actualTableName => 'pgp_key';
  @override
  VerificationContext validateIntegrity(Insertable<LocalPgpKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key'], _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private'], _isPrivateMeta));
    } else if (isInserting) {
      context.missing(_isPrivateMeta);
    }
    if (data.containsKey('length')) {
      context.handle(_lengthMeta,
          length.isAcceptableOrUnknown(data['length'], _lengthMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPgpKey map(Map<String, dynamic> data, {String tablePrefix}) {
    return LocalPgpKey.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PgpKeyTable createAlias(String alias) {
    return $PgpKeyTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FilesTable _files;
  $FilesTable get files => _files ??= $FilesTable(this);
  $PgpKeyTable _pgpKey;
  $PgpKeyTable get pgpKey => _pgpKey ??= $PgpKeyTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [files, pgpKey];
}
