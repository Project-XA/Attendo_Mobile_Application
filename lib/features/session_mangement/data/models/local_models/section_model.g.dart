// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionModelAdapter extends TypeAdapter<SectionModel> {
  @override
  final int typeId = 8;

  @override
  SectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SectionModel(
      id: fields[0] as int,
      sectionName: fields[1] as String,
      organizationId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SectionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sectionName)
      ..writeByte(2)
      ..write(obj.organizationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
