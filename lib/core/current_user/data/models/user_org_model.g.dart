// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_org_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserOrgModelAdapter extends TypeAdapter<UserOrgModel> {
  @override
  final int typeId = 1;

  @override
  UserOrgModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrgModel(
      organizationId: fields[0] as int,
      role: fields[1] as String,
      organizationName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserOrgModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.organizationId)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.organizationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOrgModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOrgModel _$UserOrgModelFromJson(Map<String, dynamic> json) => UserOrgModel(
      organizationId: (json['organizationId'] as num).toInt(),
      role: json['role'] as String,
      organizationName: json['organizationName'] as String?,
    );

Map<String, dynamic> _$UserOrgModelToJson(UserOrgModel instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'role': instance.role,
      'organizationName': instance.organizationName,
    };
