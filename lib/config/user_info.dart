import '../store/user_info.dart';
import '../utils/error_utils.dart';

class UserInfoConfig {
  factory UserInfoConfig({
    required UserInfo userInfo,
  }) {
    _instance = UserInfoConfig._internal(userInfo);
    ErrorUtils.configureUser(userInfo);
    return _instance;
  }

  UserInfoConfig._internal(this.userInfo);

  final UserInfo userInfo;
  static late UserInfoConfig _instance;

  static UserInfoConfig get instance {
    return _instance;
  }

  static String getToken() => _instance.userInfo.token ?? '';

  static String getMemberId() => _instance.userInfo.memberId ?? '';

  static String getLoginPhone() => _instance.userInfo.loginPhone ?? '';

  static String getOaAccount() => _instance.userInfo.oaAccount ?? '';

  static String getUserName() => _instance.userInfo.userName ?? '';
}
