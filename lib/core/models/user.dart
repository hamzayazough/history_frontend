import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:history_timeline/core/constants/app_constants.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String firebaseUid,
    String? email,
    String? displayName,
    required int reportCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
