// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationModelAdapter extends TypeAdapter<OrganizationModel> {
  @override
  final int typeId = 2;

  @override
  OrganizationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationModel(
      organizationId: fields[0] as int,
      organizationName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.organizationId)
      ..writeByte(1)
      ..write(obj.organizationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) =>
    OrganizationModel(
      organizationId: (json['organizationId'] as num).toInt(),
      organizationName: json['organizationName'] as String,
    );

Map<String, dynamic> _$OrganizationModelToJson(OrganizationModel instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
    };
