import 'package:isar/isar.dart';

part 'user_info.g.dart';

@collection
class UserInfo {
  UserInfo({
    this.id,
    required this.token,
    required this.memberId,
  });

  Id? id;

  String token;
  String memberId;
}
