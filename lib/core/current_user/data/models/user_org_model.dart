import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/current_user/domain/entities/user_org.dart';

part 'user_org_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserOrgModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'organizationId')
  int organizationId;
  @HiveField(1)
  String role;
  @HiveField(2)
  String? organizationName;
  UserOrgModel({required this.organizationId, required this.role, this.organizationName});
  factory UserOrgModel.fromJson(Map<String, dynamic> json) =>
      _$UserOrgModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserOrgModelToJson(this);

  factory UserOrgModel.fromEntity(UserOrg userOrg) {
    return UserOrgModel(organizationId: userOrg.organizationId, role: userOrg.role, organizationName: userOrg.organizationName);
  }
}
