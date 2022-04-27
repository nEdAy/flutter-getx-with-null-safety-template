import 'package:json_annotation/json_annotation.dart';

part 'hitokoto_response.g.dart';

@JsonSerializable()
class HitokotoResponse {
  String? hitokoto;
  String? from;

  HitokotoResponse({this.hitokoto, this.from});

  factory HitokotoResponse.fromJson(Map<String, dynamic> json) =>
      _$HitokotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HitokotoResponseToJson(this);
}
