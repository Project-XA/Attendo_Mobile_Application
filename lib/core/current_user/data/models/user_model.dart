// data/models/user_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/current_user/data/models/user_org_model.dart';
import 'package:mobile_app/core/current_user/domain/entities/user.dart';
import 'package:mobile_app/core/current_user/domain/entities/user_org.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? collegeCardId;

  @HiveField(4)
  String? profileImage;

  @HiveField(5)
  List<UserOrgModel>? organizations;
  @HiveField(6)
  String? username;
  @HiveField(7)
  String? role;
  @HiveField(8)
  bool? isUniversity;

  UserModel({
    this.isUniversity,
    this.id,
    required this.fullName,
    this.email,
    this.collegeCardId,
    this.profileImage,
    this.organizations,
    this.username,
    this.role,
  });

  /// JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      isUniversity: user.isUniversity,
      username: user.username,
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      collegeCardId: user.collegeCardId,
      role: user.role,
      profileImage: user.profileImage,
      organizations: user.organizations
          ?.map((e) => UserOrgModel.fromEntity(e))
          .toList(),
    );
  }

  User toEntity() {
    return User(
      username: username,
      id: id,
      isUniversity: isUniversity,
      fullName: fullName,
      email: email,
      collegeCardId: collegeCardId,
      profileImage: profileImage,
      role: role,
      organizations: organizations
          ?.map(
            (e) => UserOrg(
              organizationId: e.organizationId,
              role: e.role,
              organizationName: e.organizationName,
            ),
          )
          .toList(),
    );
  }

  /// copyWith
  UserModel copyWith({
    String? username,
    String? id,
    String? fullName,
    String? email,
    String? collegeCardId,
    String? profileImage,
    List<UserOrgModel>? organizations,
    String? role,
    bool? isUniversity,
  }) {
    return UserModel(
      isUniversity: isUniversity ?? this.isUniversity,
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      collegeCardId: collegeCardId ?? this.collegeCardId,
      profileImage: profileImage ?? this.profileImage,
      organizations: organizations ?? this.organizations,
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }
}
