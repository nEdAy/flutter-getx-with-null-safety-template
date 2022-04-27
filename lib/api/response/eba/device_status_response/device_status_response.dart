import 'package:json_annotation/json_annotation.dart';

part 'device_status_response.g.dart';

@JsonSerializable()
class DeviceStatusResponse {
  int? onlineCount = 0;
  int? bugCount = 0;
  int? stopCount = 0;

  DeviceStatusResponse({this.onlineCount,this.bugCount,this.stopCount});

  factory DeviceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStatusResponseToJson(this);
}