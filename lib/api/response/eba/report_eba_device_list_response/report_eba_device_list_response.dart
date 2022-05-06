import 'package:json_annotation/json_annotation.dart';

part 'report_eba_device_list_response.g.dart';

@JsonSerializable()
class ReportRbaDeviceListResponse {
  List<EbaDevice>? ebaDeviceList;

  ReportRbaDeviceListResponse({this.ebaDeviceList});

  List<EbaDevice> getBugAndStopEbaDeviceList() {
    final abnormalEbaDeviceList = <EbaDevice>[];
    ebaDeviceList?.forEach((ebaDevice) {
      if (ebaDevice.status != 1) {
        abnormalEbaDeviceList.add(ebaDevice);
      }
    });
    return abnormalEbaDeviceList;
  }

  factory ReportRbaDeviceListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportRbaDeviceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRbaDeviceListResponseToJson(this);
}

@JsonSerializable()
class EbaDevice {
  String? deviceName;
  int? status;

  EbaDevice({this.deviceName, this.status});

  factory EbaDevice.fromJson(Map<String, dynamic> json) =>
      _$EbaDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$EbaDeviceToJson(this);

  String getStatusString() {
    switch (status) {
      case 1:
        return '正常';
      case 2:
        return '故障';
      case 3:
        return '停用';
      default:
        return '其它';
    }
  }
}
