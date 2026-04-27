// domain/entities/user.dart
import 'package:mobile_app/core/current_user/domain/entities/user_org.dart';

class User {
  final String? id;
  final String fullName;
  final String? email;
  final String? collegeCardId;
  final List<UserOrg>? organizations;
  final String? profileImage;
  final String? username;
  final String? role;
  final bool? isUniversity;

  User({
    this.isUniversity,
    this.id,
    required this.fullName,
    this.email,
    this.collegeCardId,
    this.organizations,
    this.profileImage,
    this.username,
    this.role,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? collegeCardId,
    List<UserOrg>? organizations,
    String? profileImage,
    String? username,
    String? role,
    bool? isUniversity
  }) {
    return User(
      isUniversity: isUniversity?? this.isUniversity,
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      collegeCardId: collegeCardId ?? this.collegeCardId,
      organizations: organizations ?? this.organizations,
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }

  /// Getters
  bool get isRegistered => email != null && organizations != null;
}
