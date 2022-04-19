import 'package:json_annotation/json_annotation.dart';

part 'report_response.g.dart';

@JsonSerializable()
class ReportResponse {
  String? devicesRoomName;
  List<FaultDevice>? faultDevices;

  ReportResponse({this.devicesRoomName, this.faultDevices});

  factory ReportResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportResponseToJson(this);
}

@JsonSerializable()
class FaultDevice {
  String? faultDeviceName;
  String? faultDeviceReason;

  FaultDevice({this.faultDeviceName, this.faultDeviceReason});

  factory FaultDevice.fromJson(Map<String, dynamic> json) =>
      _$FaultDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$FaultDeviceToJson(this);
}
