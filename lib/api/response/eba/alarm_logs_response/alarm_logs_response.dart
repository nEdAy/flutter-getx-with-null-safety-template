import 'package:json_annotation/json_annotation.dart';

part 'alarm_logs_response.g.dart';

@JsonSerializable()
class AlarmLogsResponse {
  int? commonly = 0;
  int? serious = 0;

  AlarmLogsResponse({this.commonly,this.serious});

  factory AlarmLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmLogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmLogsResponseToJson(this);
}