class UserInfoValues {
  final String token;
  final String memberId;

  UserInfoValues({required this.token, required this.memberId});
}

class UserInfoConfig {
  final UserInfoValues values;
  static late UserInfoConfig _instance;

  factory UserInfoConfig({
    required UserInfoValues values,
  }) {
    _instance = UserInfoConfig._internal(values);
    return _instance;
  }

  UserInfoConfig._internal(this.values);

  static UserInfoConfig get instance {
    return _instance;
  }

  static String getToken() => _instance.values.token;
  static String getMemberId() => _instance.values.memberId;
}
