import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

// For Authentication purposes

@freezed
sealed class AppUser with _$AppUser {
  const factory AppUser.normal({
    required String id,
    required String email,
    required String name,
    required String imageUrl,
    required String phoneNumber,
  }) = NormalUser;

  const factory AppUser.guest({
    required String id,
    @Default('Guest') String name,
  }) = GuestUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
