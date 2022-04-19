import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'response/base/base_response.dart';
import 'response/hitokoto/hitokoto_response.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET("/")
  Future<HitokotoResponse> getHitokoto(
      @Query("encode") String encode, @Query("charset") String charset,
      {@Header('noLoading') bool noLoading = false});

  @GET("/")
  Future<HttpResponse<BaseResponse<HitokotoResponse>>> getHitokotoHttpResponse(
      @Queries() Map<String, dynamic> queries);
}
