import 'package:isar/isar.dart';

part 'user_info.g.dart';

@collection
class UserInfo {
  UserInfo({
    this.id,
    this.oaAccount,
    this.password,
    this.token,
    this.memberId,
  });

  Id? id;

  String? oaAccount;
  String? password;
  String? token;
  String? memberId;
}
