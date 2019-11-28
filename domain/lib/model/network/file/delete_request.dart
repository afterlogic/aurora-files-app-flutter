import 'package:domain/model/network/file/file_to_delete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_request.g.dart';

@JsonSerializable()
class DeleteRequest {
  final String type;
  final String path;
  final List<FileToDelete> items;

  DeleteRequest(this.type, this.path, this.items);

  factory DeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteRequestToJson(this);
}
