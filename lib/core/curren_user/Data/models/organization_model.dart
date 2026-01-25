import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/curren_user/domain/entities/organization.dart';
part 'organization_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class OrganizationModel extends HiveObject {
  @HiveField(0)
  int organizationId;
  @HiveField(1)
  String organizationName;

  OrganizationModel({required this.organizationId, required this.organizationName});
  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);

  factory OrganizationModel.fromEntity(Organization organization) {
    return OrganizationModel(
      organizationId: organization.organizationId,
      organizationName: organization.organizationName,
    );
  }
  Organization toEntity() {
    return Organization(organizationId: organizationId, organizationName: organizationName);
  }
}
