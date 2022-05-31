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
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'alarm_condition')
  String? alarmCondition;
  @JsonKey(name: 'alarm_time')
  String? alarmTime;

  AlarmLogs(
      {this.deviceName,
      this.name,
      this.alarmCondition,
      this.alarmTime});

  String getAlarmFormatLocalTime() {
    final time = alarmTime;
    if (time == null) {
      return '';
    }
    // final utcTime = DateTime.parse(time);
    // final localTime = utcTime.toLocal();
    final localTime = DateTime.parse(time);
    String formatLocalTime =
        "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}:${localTime.second.toString().padLeft(2, '0')}";
    return formatLocalTime;
  }

  factory AlarmLogs.fromJson(Map<String, dynamic> json) =>
      _$AlarmLogsFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmLogsToJson(this);
}
