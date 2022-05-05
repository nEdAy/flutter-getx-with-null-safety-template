import 'package:json_annotation/json_annotation.dart';

part 'alarm_logs_list_response.g.dart';

@JsonSerializable()
class AlarmLogsListResponse {
  int? count = 0;
  @JsonKey(name: 'list')
  List<AlarmLogs>? alarmLogsList;

  AlarmLogsListResponse({this.count, this.alarmLogsList});

  factory AlarmLogsListResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmLogsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmLogsListResponseToJson(this);
}

@JsonSerializable()
class AlarmLogs {
  @JsonKey(name: 'device_name')
  String? deviceName;
  @JsonKey(name: 'alarm_content')
  String? alarmContent;
  @JsonKey(name: 'alarm_condition')
  String? alarmCondition;
  @JsonKey(name: 'alarm_time')
  String? alarmTime;

  AlarmLogs(
      {this.deviceName,
      this.alarmContent,
      this.alarmCondition,
      this.alarmTime});

  factory AlarmLogs.fromJson(Map<String, dynamic> json) =>
      _$AlarmLogsFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmLogsToJson(this);
}
