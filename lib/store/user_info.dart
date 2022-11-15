import 'package:isar/isar.dart';

part 'user_info.g.dart';

@collection
class UserInfo {
  UserInfo({
    this.id,
    this.oaAccount,
    this.password,
    this.userName,
    this.loginPhone,
    this.token,
    this.memberId,
  });

  Id? id;

  String? oaAccount;
  String? password;
  String? userName;
  String? loginPhone;
  String? token;
  String? memberId;
}
