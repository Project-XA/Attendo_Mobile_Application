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
      isUniversity: fields[8] as bool?,
      id: fields[0] as String?,
      fullName: fields[1] as String,
      email: fields[2] as String?,
      collegeCardId: fields[3] as String?,
      profileImage: fields[4] as String?,
      organizations: (fields[5] as List?)?.cast<UserOrgModel>(),
      username: fields[6] as String?,
      role: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.collegeCardId)
      ..writeByte(4)
      ..write(obj.profileImage)
      ..writeByte(5)
      ..write(obj.organizations)
      ..writeByte(6)
      ..write(obj.username)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.isUniversity);
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
      isUniversity: json['isUniversity'] as bool?,
      id: json['id'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      collegeCardId: json['collegeCardId'] as String?,
      profileImage: json['profileImage'] as String?,
      organizations: (json['organizations'] as List<dynamic>?)
          ?.map((e) => UserOrgModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      username: json['username'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'collegeCardId': instance.collegeCardId,
      'profileImage': instance.profileImage,
      'organizations': instance.organizations,
      'username': instance.username,
      'role': instance.role,
      'isUniversity': instance.isUniversity,
    };
