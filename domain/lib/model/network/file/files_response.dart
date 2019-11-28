import 'package:domain/model/bd/local_file.dart';
import 'package:domain/model/network/file/quota.dart';
import 'package:json_annotation/json_annotation.dart';

part 'files_response.g.dart';

@JsonSerializable()
class FilesResponse {
  final List<LocalFile> items;
  final Quota quota;

  FilesResponse(this.items, this.quota);

  factory FilesResponse.fromJson(Map<String, dynamic> json) =>
      _$FilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FilesResponseToJson(this);
}
