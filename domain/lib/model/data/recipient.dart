import 'package:json_annotation/json_annotation.dart';

part 'recipient.g.dart';

@JsonSerializable()
class Recipient{
  final String email;
  final int idUser;
  final String fullName;

  Recipient(this.email, this.idUser, this.fullName);


  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}