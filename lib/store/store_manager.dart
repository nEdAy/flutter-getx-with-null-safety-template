import 'package:shared_preferences/shared_preferences.dart';

const kLastUsername = 'lastUsername';
const kAccessToken = 'accessToken';
const kRefreshToken = 'refreshToken';

class StoreManager {
  final SharedPreferencesWithCache pref;
  static late StoreManager _instance;

  factory StoreManager({required SharedPreferencesWithCache pref}) {
    _instance = StoreManager._internal(pref);
    return _instance;
  }

  StoreManager._internal(this.pref);

  static StoreManager get instance {
    return _instance;
  }
}
