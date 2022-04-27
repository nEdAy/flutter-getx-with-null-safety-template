import 'package:json_annotation/json_annotation.dart';

part 'device_status_response.g.dart';

@JsonSerializable()
class DeviceStatusResponse {
  int? onlineCount = 0;
  int? bugCount = 0;
  int? stopCount = 0;
  double? onlineRate = 0;
  int? onlineDay = 0;

  DeviceStatusResponse({this.onlineCount,this.bugCount,this.stopCount,this.onlineRate,this.onlineDay});

  factory DeviceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStatusResponseToJson(this);
}