import 'package:json_annotation/json_annotation.dart';

part 'report_device_status_response.g.dart';

@JsonSerializable()
class ReportDeviceStatusResponse {
  List<DeviceStatisticsVo>? deviceStatisticsVoList;
  int? deviceSpaceAllNum = 0;
  int? deviceSpaceBugNum = 0;
  int? deviceAllNum = 0;
  int? deviceBugNum = 0;

  ReportDeviceStatusResponse(
      {this.deviceSpaceAllNum,
      this.deviceSpaceBugNum,
      this.deviceAllNum,
      this.deviceBugNum});

  factory ReportDeviceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportDeviceStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDeviceStatusResponseToJson(this);
}

@JsonSerializable()
class DeviceStatisticsVo {
  String? spaceName;
  int? bugCount;
  int? stopCount;

  DeviceStatisticsVo({this.spaceName, this.bugCount, this.stopCount});

  int abnormalEbaCount() => (bugCount ?? 0) + (stopCount ?? 0);

  factory DeviceStatisticsVo.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatisticsVoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStatisticsVoToJson(this);
}
