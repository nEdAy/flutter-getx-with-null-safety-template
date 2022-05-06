import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'response/base/base_response.dart';
import 'response/eba/alarm_logs_list_response/alarm_logs_list_response.dart';
import 'response/eba/alarm_logs_response/alarm_logs_response.dart';
import 'response/eba/device_status_response/device_status_response.dart';
import 'response/eba/project_list_response/project_list_response.dart';
import 'response/hitokoto/hitokoto_response.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET("https://v1.hitokoto.cn/")
  Future<HitokotoResponse> getHitokoto(
      @Query("encode") String encode, @Query("charset") String charset,
      {@Header('noLoading') bool noLoading = false});

  @GET("/v2/corp/organization/member/id/{memberId}/project_list")
  Future<BaseResponse<ProjectListResponse>> getProjectList(
      @Path("memberId") String memberId, @Header("group") String group);

  @GET("/v2/service/device-manage/device-info/statistic/device-run-status")
  Future<BaseResponse<DeviceStatusResponse>> getDeviceStatus(
      @Query("projectId") String projectId, @Header("group") String group);

  @GET("/v2/service/device-manage/device-alarm/statistics/alarm-logs")
  Future<BaseResponse<AlarmLogsResponse>> getAlarmLogs(
      @Query("projectId") String projectId, @Header("group") String group);

  @POST("/v2/service/device-manage/device-alarm/alarm-logs-list")
  Future<BaseResponse<AlarmLogsListResponse>> getAlarmLogsList(
      @Body() Map<String, dynamic> request, @Header("group") String group,
      {@Header('noLoading') bool noLoading = false});
}
