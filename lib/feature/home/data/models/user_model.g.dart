// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      nationalId: fields[0] as String,
      fullName: fields[1] as String,
      birthDate: fields[2] as String?,
      email: fields[3] as String,
      organizations: (fields[4] as List).cast<UserOrgModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nationalId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.organizations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      nationalId: json['nationalId'] as String,
      fullName: json['fullName'] as String,
      birthDate: json['birthDate'] as String?,
      email: json['email'] as String,
      organizations: (json['organizations'] as List<dynamic>)
          .map((e) => UserOrgModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'nationalId': instance.nationalId,
      'fullName': instance.fullName,
      'birthDate': instance.birthDate,
      'email': instance.email,
      'organizations': instance.organizations,
    };
