// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class File extends DataClass implements Insertable<File> {
  final int localId;
  final String Id;
  final String Type;
  final String Path;
  final String FullPath;
  final String Name;
  final int Size;
  final bool IsFolder;
  final bool IsLink;
  final String LinkType;
  final String LinkUrl;
  final int LastModified;
  final String ContentType;
  final bool Thumb;
  final String ThumbnailLink;
  final String OembedHtml;
  final bool Shared;
  final String Owner;
  final String Content;
  final String ViewUrl;
  final String DownloadUrl;
  final String ThumbnailUrl;
  final String Hash;
  final bool IsExternal;
  File(
      {@required this.localId,
      @required this.Id,
      @required this.Type,
      @required this.Path,
      @required this.FullPath,
      @required this.Name,
      @required this.Size,
      @required this.IsFolder,
      @required this.IsLink,
      @required this.LinkType,
      @required this.LinkUrl,
      @required this.LastModified,
      @required this.ContentType,
      @required this.Thumb,
      @required this.ThumbnailLink,
      @required this.OembedHtml,
      @required this.Shared,
      @required this.Owner,
      @required this.Content,
      @required this.ViewUrl,
      @required this.DownloadUrl,
      @required this.ThumbnailUrl,
      @required this.Hash,
      @required this.IsExternal});
  factory File.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return File(
      localId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}local_id']),
      Id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      Type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      Path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      FullPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}full_path']),
      Name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      Size: intType.mapFromDatabaseResponse(data['${effectivePrefix}size']),
      IsFolder:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_folder']),
      IsLink:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_link']),
      LinkType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}link_type']),
      LinkUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}link_url']),
      LastModified: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_modified']),
      ContentType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}content_type']),
      Thumb: boolType.mapFromDatabaseResponse(data['${effectivePrefix}thumb']),
      ThumbnailLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_link']),
      OembedHtml: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}oembed_html']),
      Shared:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}shared']),
      Owner:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}owner']),
      Content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      ViewUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}view_url']),
      DownloadUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}download_url']),
      ThumbnailUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_url']),
      Hash: stringType.mapFromDatabaseResponse(data['${effectivePrefix}hash']),
      IsExternal: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_external']),
    );
  }
  factory File.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return File(
      localId: serializer.fromJson<int>(json['localId']),
      Id: serializer.fromJson<String>(json['Id']),
      Type: serializer.fromJson<String>(json['Type']),
      Path: serializer.fromJson<String>(json['Path']),
      FullPath: serializer.fromJson<String>(json['FullPath']),
      Name: serializer.fromJson<String>(json['Name']),
      Size: serializer.fromJson<int>(json['Size']),
      IsFolder: serializer.fromJson<bool>(json['IsFolder']),
      IsLink: serializer.fromJson<bool>(json['IsLink']),
      LinkType: serializer.fromJson<String>(json['LinkType']),
      LinkUrl: serializer.fromJson<String>(json['LinkUrl']),
      LastModified: serializer.fromJson<int>(json['LastModified']),
      ContentType: serializer.fromJson<String>(json['ContentType']),
      Thumb: serializer.fromJson<bool>(json['Thumb']),
      ThumbnailLink: serializer.fromJson<String>(json['ThumbnailLink']),
      OembedHtml: serializer.fromJson<String>(json['OembedHtml']),
      Shared: serializer.fromJson<bool>(json['Shared']),
      Owner: serializer.fromJson<String>(json['Owner']),
      Content: serializer.fromJson<String>(json['Content']),
      ViewUrl: serializer.fromJson<String>(json['ViewUrl']),
      DownloadUrl: serializer.fromJson<String>(json['DownloadUrl']),
      ThumbnailUrl: serializer.fromJson<String>(json['ThumbnailUrl']),
      Hash: serializer.fromJson<String>(json['Hash']),
      IsExternal: serializer.fromJson<bool>(json['IsExternal']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'localId': serializer.toJson<int>(localId),
      'Id': serializer.toJson<String>(Id),
      'Type': serializer.toJson<String>(Type),
      'Path': serializer.toJson<String>(Path),
      'FullPath': serializer.toJson<String>(FullPath),
      'Name': serializer.toJson<String>(Name),
      'Size': serializer.toJson<int>(Size),
      'IsFolder': serializer.toJson<bool>(IsFolder),
      'IsLink': serializer.toJson<bool>(IsLink),
      'LinkType': serializer.toJson<String>(LinkType),
      'LinkUrl': serializer.toJson<String>(LinkUrl),
      'LastModified': serializer.toJson<int>(LastModified),
      'ContentType': serializer.toJson<String>(ContentType),
      'Thumb': serializer.toJson<bool>(Thumb),
      'ThumbnailLink': serializer.toJson<String>(ThumbnailLink),
      'OembedHtml': serializer.toJson<String>(OembedHtml),
      'Shared': serializer.toJson<bool>(Shared),
      'Owner': serializer.toJson<String>(Owner),
      'Content': serializer.toJson<String>(Content),
      'ViewUrl': serializer.toJson<String>(ViewUrl),
      'DownloadUrl': serializer.toJson<String>(DownloadUrl),
      'ThumbnailUrl': serializer.toJson<String>(ThumbnailUrl),
      'Hash': serializer.toJson<String>(Hash),
      'IsExternal': serializer.toJson<bool>(IsExternal),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<File>>(bool nullToAbsent) {
    return FilesCompanion(
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      Id: Id == null && nullToAbsent ? const Value.absent() : Value(Id),
      Type: Type == null && nullToAbsent ? const Value.absent() : Value(Type),
      Path: Path == null && nullToAbsent ? const Value.absent() : Value(Path),
      FullPath: FullPath == null && nullToAbsent
          ? const Value.absent()
          : Value(FullPath),
      Name: Name == null && nullToAbsent ? const Value.absent() : Value(Name),
      Size: Size == null && nullToAbsent ? const Value.absent() : Value(Size),
      IsFolder: IsFolder == null && nullToAbsent
          ? const Value.absent()
          : Value(IsFolder),
      IsLink:
          IsLink == null && nullToAbsent ? const Value.absent() : Value(IsLink),
      LinkType: LinkType == null && nullToAbsent
          ? const Value.absent()
          : Value(LinkType),
      LinkUrl: LinkUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(LinkUrl),
      LastModified: LastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(LastModified),
      ContentType: ContentType == null && nullToAbsent
          ? const Value.absent()
          : Value(ContentType),
      Thumb:
          Thumb == null && nullToAbsent ? const Value.absent() : Value(Thumb),
      ThumbnailLink: ThumbnailLink == null && nullToAbsent
          ? const Value.absent()
          : Value(ThumbnailLink),
      OembedHtml: OembedHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(OembedHtml),
      Shared:
          Shared == null && nullToAbsent ? const Value.absent() : Value(Shared),
      Owner:
          Owner == null && nullToAbsent ? const Value.absent() : Value(Owner),
      Content: Content == null && nullToAbsent
          ? const Value.absent()
          : Value(Content),
      ViewUrl: ViewUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(ViewUrl),
      DownloadUrl: DownloadUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(DownloadUrl),
      ThumbnailUrl: ThumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(ThumbnailUrl),
      Hash: Hash == null && nullToAbsent ? const Value.absent() : Value(Hash),
      IsExternal: IsExternal == null && nullToAbsent
          ? const Value.absent()
          : Value(IsExternal),
    ) as T;
  }

  File copyWith(
          {int localId,
          String Id,
          String Type,
          String Path,
          String FullPath,
          String Name,
          int Size,
          bool IsFolder,
          bool IsLink,
          String LinkType,
          String LinkUrl,
          int LastModified,
          String ContentType,
          bool Thumb,
          String ThumbnailLink,
          String OembedHtml,
          bool Shared,
          String Owner,
          String Content,
          String ViewUrl,
          String DownloadUrl,
          String ThumbnailUrl,
          String Hash,
          bool IsExternal}) =>
      File(
        localId: localId ?? this.localId,
        Id: Id ?? this.Id,
        Type: Type ?? this.Type,
        Path: Path ?? this.Path,
        FullPath: FullPath ?? this.FullPath,
        Name: Name ?? this.Name,
        Size: Size ?? this.Size,
        IsFolder: IsFolder ?? this.IsFolder,
        IsLink: IsLink ?? this.IsLink,
        LinkType: LinkType ?? this.LinkType,
        LinkUrl: LinkUrl ?? this.LinkUrl,
        LastModified: LastModified ?? this.LastModified,
        ContentType: ContentType ?? this.ContentType,
        Thumb: Thumb ?? this.Thumb,
        ThumbnailLink: ThumbnailLink ?? this.ThumbnailLink,
        OembedHtml: OembedHtml ?? this.OembedHtml,
        Shared: Shared ?? this.Shared,
        Owner: Owner ?? this.Owner,
        Content: Content ?? this.Content,
        ViewUrl: ViewUrl ?? this.ViewUrl,
        DownloadUrl: DownloadUrl ?? this.DownloadUrl,
        ThumbnailUrl: ThumbnailUrl ?? this.ThumbnailUrl,
        Hash: Hash ?? this.Hash,
        IsExternal: IsExternal ?? this.IsExternal,
      );
  @override
  String toString() {
    return (StringBuffer('File(')
          ..write('localId: $localId, ')
          ..write('Id: $Id, ')
          ..write('Type: $Type, ')
          ..write('Path: $Path, ')
          ..write('FullPath: $FullPath, ')
          ..write('Name: $Name, ')
          ..write('Size: $Size, ')
          ..write('IsFolder: $IsFolder, ')
          ..write('IsLink: $IsLink, ')
          ..write('LinkType: $LinkType, ')
          ..write('LinkUrl: $LinkUrl, ')
          ..write('LastModified: $LastModified, ')
          ..write('ContentType: $ContentType, ')
          ..write('Thumb: $Thumb, ')
          ..write('ThumbnailLink: $ThumbnailLink, ')
          ..write('OembedHtml: $OembedHtml, ')
          ..write('Shared: $Shared, ')
          ..write('Owner: $Owner, ')
          ..write('Content: $Content, ')
          ..write('ViewUrl: $ViewUrl, ')
          ..write('DownloadUrl: $DownloadUrl, ')
          ..write('ThumbnailUrl: $ThumbnailUrl, ')
          ..write('Hash: $Hash, ')
          ..write('IsExternal: $IsExternal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc(
                              $mrjc(
                                  $mrjc(
                                      $mrjc(
                                          $mrjc(
                                              $mrjc(
                                                  $mrjc(
                                                      $mrjc(
                                                          $mrjc(
                                                              $mrjc(
                                                                  $mrjc(
                                                                      $mrjc(
                                                                          $mrjc(
                                                                              $mrjc($mrjc($mrjc($mrjc($mrjc(0, localId.hashCode), Id.hashCode), Type.hashCode), Path.hashCode), FullPath.hashCode),
                                                                              Name.hashCode),
                                                                          Size.hashCode),
                                                                      IsFolder.hashCode),
                                                                  IsLink.hashCode),
                                                              LinkType.hashCode),
                                                          LinkUrl.hashCode),
                                                      LastModified.hashCode),
                                                  ContentType.hashCode),
                                              Thumb.hashCode),
                                          ThumbnailLink.hashCode),
                                      OembedHtml.hashCode),
                                  Shared.hashCode),
                              Owner.hashCode),
                          Content.hashCode),
                      ViewUrl.hashCode),
                  DownloadUrl.hashCode),
              ThumbnailUrl.hashCode),
          Hash.hashCode),
      IsExternal.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is File &&
          other.localId == localId &&
          other.Id == Id &&
          other.Type == Type &&
          other.Path == Path &&
          other.FullPath == FullPath &&
          other.Name == Name &&
          other.Size == Size &&
          other.IsFolder == IsFolder &&
          other.IsLink == IsLink &&
          other.LinkType == LinkType &&
          other.LinkUrl == LinkUrl &&
          other.LastModified == LastModified &&
          other.ContentType == ContentType &&
          other.Thumb == Thumb &&
          other.ThumbnailLink == ThumbnailLink &&
          other.OembedHtml == OembedHtml &&
          other.Shared == Shared &&
          other.Owner == Owner &&
          other.Content == Content &&
          other.ViewUrl == ViewUrl &&
          other.DownloadUrl == DownloadUrl &&
          other.ThumbnailUrl == ThumbnailUrl &&
          other.Hash == Hash &&
          other.IsExternal == IsExternal);
}

class FilesCompanion extends UpdateCompanion<File> {
  final Value<int> localId;
  final Value<String> Id;
  final Value<String> Type;
  final Value<String> Path;
  final Value<String> FullPath;
  final Value<String> Name;
  final Value<int> Size;
  final Value<bool> IsFolder;
  final Value<bool> IsLink;
  final Value<String> LinkType;
  final Value<String> LinkUrl;
  final Value<int> LastModified;
  final Value<String> ContentType;
  final Value<bool> Thumb;
  final Value<String> ThumbnailLink;
  final Value<String> OembedHtml;
  final Value<bool> Shared;
  final Value<String> Owner;
  final Value<String> Content;
  final Value<String> ViewUrl;
  final Value<String> DownloadUrl;
  final Value<String> ThumbnailUrl;
  final Value<String> Hash;
  final Value<bool> IsExternal;
  const FilesCompanion({
    this.localId = const Value.absent(),
    this.Id = const Value.absent(),
    this.Type = const Value.absent(),
    this.Path = const Value.absent(),
    this.FullPath = const Value.absent(),
    this.Name = const Value.absent(),
    this.Size = const Value.absent(),
    this.IsFolder = const Value.absent(),
    this.IsLink = const Value.absent(),
    this.LinkType = const Value.absent(),
    this.LinkUrl = const Value.absent(),
    this.LastModified = const Value.absent(),
    this.ContentType = const Value.absent(),
    this.Thumb = const Value.absent(),
    this.ThumbnailLink = const Value.absent(),
    this.OembedHtml = const Value.absent(),
    this.Shared = const Value.absent(),
    this.Owner = const Value.absent(),
    this.Content = const Value.absent(),
    this.ViewUrl = const Value.absent(),
    this.DownloadUrl = const Value.absent(),
    this.ThumbnailUrl = const Value.absent(),
    this.Hash = const Value.absent(),
    this.IsExternal = const Value.absent(),
  });
}

class $FilesTable extends Files with TableInfo<$FilesTable, File> {
  final GeneratedDatabase _db;
  final String _alias;
  $FilesTable(this._db, [this._alias]);
  final VerificationMeta _localIdMeta = const VerificationMeta('localId');
  GeneratedIntColumn _localId;
  @override
  GeneratedIntColumn get localId => _localId ??= _constructLocalId();
  GeneratedIntColumn _constructLocalId() {
    return GeneratedIntColumn('local_id', $tableName, false,
        hasAutoIncrement: true);
  }

  final VerificationMeta _IdMeta = const VerificationMeta('Id');
  GeneratedTextColumn _Id;
  @override
  GeneratedTextColumn get Id => _Id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _TypeMeta = const VerificationMeta('Type');
  GeneratedTextColumn _Type;
  @override
  GeneratedTextColumn get Type => _Type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _PathMeta = const VerificationMeta('Path');
  GeneratedTextColumn _Path;
  @override
  GeneratedTextColumn get Path => _Path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _FullPathMeta = const VerificationMeta('FullPath');
  GeneratedTextColumn _FullPath;
  @override
  GeneratedTextColumn get FullPath => _FullPath ??= _constructFullPath();
  GeneratedTextColumn _constructFullPath() {
    return GeneratedTextColumn(
      'full_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _NameMeta = const VerificationMeta('Name');
  GeneratedTextColumn _Name;
  @override
  GeneratedTextColumn get Name => _Name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _SizeMeta = const VerificationMeta('Size');
  GeneratedIntColumn _Size;
  @override
  GeneratedIntColumn get Size => _Size ??= _constructSize();
  GeneratedIntColumn _constructSize() {
    return GeneratedIntColumn(
      'size',
      $tableName,
      false,
    );
  }

  final VerificationMeta _IsFolderMeta = const VerificationMeta('IsFolder');
  GeneratedBoolColumn _IsFolder;
  @override
  GeneratedBoolColumn get IsFolder => _IsFolder ??= _constructIsFolder();
  GeneratedBoolColumn _constructIsFolder() {
    return GeneratedBoolColumn(
      'is_folder',
      $tableName,
      false,
    );
  }

  final VerificationMeta _IsLinkMeta = const VerificationMeta('IsLink');
  GeneratedBoolColumn _IsLink;
  @override
  GeneratedBoolColumn get IsLink => _IsLink ??= _constructIsLink();
  GeneratedBoolColumn _constructIsLink() {
    return GeneratedBoolColumn(
      'is_link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _LinkTypeMeta = const VerificationMeta('LinkType');
  GeneratedTextColumn _LinkType;
  @override
  GeneratedTextColumn get LinkType => _LinkType ??= _constructLinkType();
  GeneratedTextColumn _constructLinkType() {
    return GeneratedTextColumn(
      'link_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _LinkUrlMeta = const VerificationMeta('LinkUrl');
  GeneratedTextColumn _LinkUrl;
  @override
  GeneratedTextColumn get LinkUrl => _LinkUrl ??= _constructLinkUrl();
  GeneratedTextColumn _constructLinkUrl() {
    return GeneratedTextColumn(
      'link_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _LastModifiedMeta =
      const VerificationMeta('LastModified');
  GeneratedIntColumn _LastModified;
  @override
  GeneratedIntColumn get LastModified =>
      _LastModified ??= _constructLastModified();
  GeneratedIntColumn _constructLastModified() {
    return GeneratedIntColumn(
      'last_modified',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ContentTypeMeta =
      const VerificationMeta('ContentType');
  GeneratedTextColumn _ContentType;
  @override
  GeneratedTextColumn get ContentType =>
      _ContentType ??= _constructContentType();
  GeneratedTextColumn _constructContentType() {
    return GeneratedTextColumn(
      'content_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ThumbMeta = const VerificationMeta('Thumb');
  GeneratedBoolColumn _Thumb;
  @override
  GeneratedBoolColumn get Thumb => _Thumb ??= _constructThumb();
  GeneratedBoolColumn _constructThumb() {
    return GeneratedBoolColumn(
      'thumb',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ThumbnailLinkMeta =
      const VerificationMeta('ThumbnailLink');
  GeneratedTextColumn _ThumbnailLink;
  @override
  GeneratedTextColumn get ThumbnailLink =>
      _ThumbnailLink ??= _constructThumbnailLink();
  GeneratedTextColumn _constructThumbnailLink() {
    return GeneratedTextColumn(
      'thumbnail_link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _OembedHtmlMeta = const VerificationMeta('OembedHtml');
  GeneratedTextColumn _OembedHtml;
  @override
  GeneratedTextColumn get OembedHtml => _OembedHtml ??= _constructOembedHtml();
  GeneratedTextColumn _constructOembedHtml() {
    return GeneratedTextColumn(
      'oembed_html',
      $tableName,
      false,
    );
  }

  final VerificationMeta _SharedMeta = const VerificationMeta('Shared');
  GeneratedBoolColumn _Shared;
  @override
  GeneratedBoolColumn get Shared => _Shared ??= _constructShared();
  GeneratedBoolColumn _constructShared() {
    return GeneratedBoolColumn(
      'shared',
      $tableName,
      false,
    );
  }

  final VerificationMeta _OwnerMeta = const VerificationMeta('Owner');
  GeneratedTextColumn _Owner;
  @override
  GeneratedTextColumn get Owner => _Owner ??= _constructOwner();
  GeneratedTextColumn _constructOwner() {
    return GeneratedTextColumn(
      'owner',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ContentMeta = const VerificationMeta('Content');
  GeneratedTextColumn _Content;
  @override
  GeneratedTextColumn get Content => _Content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ViewUrlMeta = const VerificationMeta('ViewUrl');
  GeneratedTextColumn _ViewUrl;
  @override
  GeneratedTextColumn get ViewUrl => _ViewUrl ??= _constructViewUrl();
  GeneratedTextColumn _constructViewUrl() {
    return GeneratedTextColumn(
      'view_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _DownloadUrlMeta =
      const VerificationMeta('DownloadUrl');
  GeneratedTextColumn _DownloadUrl;
  @override
  GeneratedTextColumn get DownloadUrl =>
      _DownloadUrl ??= _constructDownloadUrl();
  GeneratedTextColumn _constructDownloadUrl() {
    return GeneratedTextColumn(
      'download_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ThumbnailUrlMeta =
      const VerificationMeta('ThumbnailUrl');
  GeneratedTextColumn _ThumbnailUrl;
  @override
  GeneratedTextColumn get ThumbnailUrl =>
      _ThumbnailUrl ??= _constructThumbnailUrl();
  GeneratedTextColumn _constructThumbnailUrl() {
    return GeneratedTextColumn(
      'thumbnail_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _HashMeta = const VerificationMeta('Hash');
  GeneratedTextColumn _Hash;
  @override
  GeneratedTextColumn get Hash => _Hash ??= _constructHash();
  GeneratedTextColumn _constructHash() {
    return GeneratedTextColumn(
      'hash',
      $tableName,
      false,
    );
  }

  final VerificationMeta _IsExternalMeta = const VerificationMeta('IsExternal');
  GeneratedBoolColumn _IsExternal;
  @override
  GeneratedBoolColumn get IsExternal => _IsExternal ??= _constructIsExternal();
  GeneratedBoolColumn _constructIsExternal() {
    return GeneratedBoolColumn(
      'is_external',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        localId,
        Id,
        Type,
        Path,
        FullPath,
        Name,
        Size,
        IsFolder,
        IsLink,
        LinkType,
        LinkUrl,
        LastModified,
        ContentType,
        Thumb,
        ThumbnailLink,
        OembedHtml,
        Shared,
        Owner,
        Content,
        ViewUrl,
        DownloadUrl,
        ThumbnailUrl,
        Hash,
        IsExternal
      ];
  @override
  $FilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'files';
  @override
  final String actualTableName = 'files';
  @override
  VerificationContext validateIntegrity(FilesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.localId.present) {
      context.handle(_localIdMeta,
          localId.isAcceptableValue(d.localId.value, _localIdMeta));
    } else if (localId.isRequired && isInserting) {
      context.missing(_localIdMeta);
    }
    if (d.Id.present) {
      context.handle(_IdMeta, Id.isAcceptableValue(d.Id.value, _IdMeta));
    } else if (Id.isRequired && isInserting) {
      context.missing(_IdMeta);
    }
    if (d.Type.present) {
      context.handle(
          _TypeMeta, Type.isAcceptableValue(d.Type.value, _TypeMeta));
    } else if (Type.isRequired && isInserting) {
      context.missing(_TypeMeta);
    }
    if (d.Path.present) {
      context.handle(
          _PathMeta, Path.isAcceptableValue(d.Path.value, _PathMeta));
    } else if (Path.isRequired && isInserting) {
      context.missing(_PathMeta);
    }
    if (d.FullPath.present) {
      context.handle(_FullPathMeta,
          FullPath.isAcceptableValue(d.FullPath.value, _FullPathMeta));
    } else if (FullPath.isRequired && isInserting) {
      context.missing(_FullPathMeta);
    }
    if (d.Name.present) {
      context.handle(
          _NameMeta, Name.isAcceptableValue(d.Name.value, _NameMeta));
    } else if (Name.isRequired && isInserting) {
      context.missing(_NameMeta);
    }
    if (d.Size.present) {
      context.handle(
          _SizeMeta, Size.isAcceptableValue(d.Size.value, _SizeMeta));
    } else if (Size.isRequired && isInserting) {
      context.missing(_SizeMeta);
    }
    if (d.IsFolder.present) {
      context.handle(_IsFolderMeta,
          IsFolder.isAcceptableValue(d.IsFolder.value, _IsFolderMeta));
    } else if (IsFolder.isRequired && isInserting) {
      context.missing(_IsFolderMeta);
    }
    if (d.IsLink.present) {
      context.handle(
          _IsLinkMeta, IsLink.isAcceptableValue(d.IsLink.value, _IsLinkMeta));
    } else if (IsLink.isRequired && isInserting) {
      context.missing(_IsLinkMeta);
    }
    if (d.LinkType.present) {
      context.handle(_LinkTypeMeta,
          LinkType.isAcceptableValue(d.LinkType.value, _LinkTypeMeta));
    } else if (LinkType.isRequired && isInserting) {
      context.missing(_LinkTypeMeta);
    }
    if (d.LinkUrl.present) {
      context.handle(_LinkUrlMeta,
          LinkUrl.isAcceptableValue(d.LinkUrl.value, _LinkUrlMeta));
    } else if (LinkUrl.isRequired && isInserting) {
      context.missing(_LinkUrlMeta);
    }
    if (d.LastModified.present) {
      context.handle(
          _LastModifiedMeta,
          LastModified.isAcceptableValue(
              d.LastModified.value, _LastModifiedMeta));
    } else if (LastModified.isRequired && isInserting) {
      context.missing(_LastModifiedMeta);
    }
    if (d.ContentType.present) {
      context.handle(_ContentTypeMeta,
          ContentType.isAcceptableValue(d.ContentType.value, _ContentTypeMeta));
    } else if (ContentType.isRequired && isInserting) {
      context.missing(_ContentTypeMeta);
    }
    if (d.Thumb.present) {
      context.handle(
          _ThumbMeta, Thumb.isAcceptableValue(d.Thumb.value, _ThumbMeta));
    } else if (Thumb.isRequired && isInserting) {
      context.missing(_ThumbMeta);
    }
    if (d.ThumbnailLink.present) {
      context.handle(
          _ThumbnailLinkMeta,
          ThumbnailLink.isAcceptableValue(
              d.ThumbnailLink.value, _ThumbnailLinkMeta));
    } else if (ThumbnailLink.isRequired && isInserting) {
      context.missing(_ThumbnailLinkMeta);
    }
    if (d.OembedHtml.present) {
      context.handle(_OembedHtmlMeta,
          OembedHtml.isAcceptableValue(d.OembedHtml.value, _OembedHtmlMeta));
    } else if (OembedHtml.isRequired && isInserting) {
      context.missing(_OembedHtmlMeta);
    }
    if (d.Shared.present) {
      context.handle(
          _SharedMeta, Shared.isAcceptableValue(d.Shared.value, _SharedMeta));
    } else if (Shared.isRequired && isInserting) {
      context.missing(_SharedMeta);
    }
    if (d.Owner.present) {
      context.handle(
          _OwnerMeta, Owner.isAcceptableValue(d.Owner.value, _OwnerMeta));
    } else if (Owner.isRequired && isInserting) {
      context.missing(_OwnerMeta);
    }
    if (d.Content.present) {
      context.handle(_ContentMeta,
          Content.isAcceptableValue(d.Content.value, _ContentMeta));
    } else if (Content.isRequired && isInserting) {
      context.missing(_ContentMeta);
    }
    if (d.ViewUrl.present) {
      context.handle(_ViewUrlMeta,
          ViewUrl.isAcceptableValue(d.ViewUrl.value, _ViewUrlMeta));
    } else if (ViewUrl.isRequired && isInserting) {
      context.missing(_ViewUrlMeta);
    }
    if (d.DownloadUrl.present) {
      context.handle(_DownloadUrlMeta,
          DownloadUrl.isAcceptableValue(d.DownloadUrl.value, _DownloadUrlMeta));
    } else if (DownloadUrl.isRequired && isInserting) {
      context.missing(_DownloadUrlMeta);
    }
    if (d.ThumbnailUrl.present) {
      context.handle(
          _ThumbnailUrlMeta,
          ThumbnailUrl.isAcceptableValue(
              d.ThumbnailUrl.value, _ThumbnailUrlMeta));
    } else if (ThumbnailUrl.isRequired && isInserting) {
      context.missing(_ThumbnailUrlMeta);
    }
    if (d.Hash.present) {
      context.handle(
          _HashMeta, Hash.isAcceptableValue(d.Hash.value, _HashMeta));
    } else if (Hash.isRequired && isInserting) {
      context.missing(_HashMeta);
    }
    if (d.IsExternal.present) {
      context.handle(_IsExternalMeta,
          IsExternal.isAcceptableValue(d.IsExternal.value, _IsExternalMeta));
    } else if (IsExternal.isRequired && isInserting) {
      context.missing(_IsExternalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  File map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return File.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FilesCompanion d) {
    final map = <String, Variable>{};
    if (d.localId.present) {
      map['local_id'] = Variable<int, IntType>(d.localId.value);
    }
    if (d.Id.present) {
      map['id'] = Variable<String, StringType>(d.Id.value);
    }
    if (d.Type.present) {
      map['type'] = Variable<String, StringType>(d.Type.value);
    }
    if (d.Path.present) {
      map['path'] = Variable<String, StringType>(d.Path.value);
    }
    if (d.FullPath.present) {
      map['full_path'] = Variable<String, StringType>(d.FullPath.value);
    }
    if (d.Name.present) {
      map['name'] = Variable<String, StringType>(d.Name.value);
    }
    if (d.Size.present) {
      map['size'] = Variable<int, IntType>(d.Size.value);
    }
    if (d.IsFolder.present) {
      map['is_folder'] = Variable<bool, BoolType>(d.IsFolder.value);
    }
    if (d.IsLink.present) {
      map['is_link'] = Variable<bool, BoolType>(d.IsLink.value);
    }
    if (d.LinkType.present) {
      map['link_type'] = Variable<String, StringType>(d.LinkType.value);
    }
    if (d.LinkUrl.present) {
      map['link_url'] = Variable<String, StringType>(d.LinkUrl.value);
    }
    if (d.LastModified.present) {
      map['last_modified'] = Variable<int, IntType>(d.LastModified.value);
    }
    if (d.ContentType.present) {
      map['content_type'] = Variable<String, StringType>(d.ContentType.value);
    }
    if (d.Thumb.present) {
      map['thumb'] = Variable<bool, BoolType>(d.Thumb.value);
    }
    if (d.ThumbnailLink.present) {
      map['thumbnail_link'] =
          Variable<String, StringType>(d.ThumbnailLink.value);
    }
    if (d.OembedHtml.present) {
      map['oembed_html'] = Variable<String, StringType>(d.OembedHtml.value);
    }
    if (d.Shared.present) {
      map['shared'] = Variable<bool, BoolType>(d.Shared.value);
    }
    if (d.Owner.present) {
      map['owner'] = Variable<String, StringType>(d.Owner.value);
    }
    if (d.Content.present) {
      map['content'] = Variable<String, StringType>(d.Content.value);
    }
    if (d.ViewUrl.present) {
      map['view_url'] = Variable<String, StringType>(d.ViewUrl.value);
    }
    if (d.DownloadUrl.present) {
      map['download_url'] = Variable<String, StringType>(d.DownloadUrl.value);
    }
    if (d.ThumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String, StringType>(d.ThumbnailUrl.value);
    }
    if (d.Hash.present) {
      map['hash'] = Variable<String, StringType>(d.Hash.value);
    }
    if (d.IsExternal.present) {
      map['is_external'] = Variable<bool, BoolType>(d.IsExternal.value);
    }
    return map;
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $FilesTable _files;
  $FilesTable get files => _files ??= $FilesTable(this);
  @override
  List<TableInfo> get allTables => [files];
}
