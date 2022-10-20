import '../store/user_info.dart';

class UserInfoConfig {
  final UserInfo userInfo;
  static late UserInfoConfig _instance;

  factory UserInfoConfig({
    required UserInfo userInfo,
  }) {
    _instance = UserInfoConfig._internal(userInfo);
    return _instance;
  }

  UserInfoConfig._internal(this.userInfo);

  static UserInfoConfig get instance {
    return _instance;
  }

  static String getToken() => _instance.userInfo.token;

  static String getMemberId() => _instance.userInfo.memberId;
}
