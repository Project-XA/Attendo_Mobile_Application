import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/feature/home/data/models/user_org_model.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/domain/entities/user_org.dart';

part 'user_model.g.dart';
@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String nationalId;
  @HiveField(1)
  String fullName;
  @HiveField(2)
  String? birthDate;
  @HiveField(3)
  String email;
  @HiveField(4)
  List<UserOrgModel> organizations;
  UserModel({
    required this.nationalId,
    required this.fullName,
    this.birthDate,
    required this.email,
    required this.organizations,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // fromEntity / toEntity for Domain
 factory UserModel.fromEntity(User user) {
  return UserModel(
    nationalId: user.nationalId,
    fullName: user.fullName,
    birthDate: user.birthDate,
    email: user.email,
    organizations: user.organizations
        .map((org) => UserOrgModel.fromEntity(org))
        .toList(),
  );
}

  User toEntity() {
    return User(
      fullName.split(' ').first,
      fullName.split(' ').last,
      nationalId: nationalId,
      birthDate: birthDate,
      email: email,
      organizations: organizations
          .map(
            (orgModel) => UserOrg(orgId: orgModel.orgId, role: orgModel.role),
          )
          .toList(),
    );
  }
}
