// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_sections_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheSectionsDataAdapter extends TypeAdapter<CacheSectionsData> {
  @override
  final int typeId = 7;

  @override
  CacheSectionsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheSectionsData(
      sections: (fields[0] as List).cast<SectionModel>(),
      lastFetchTime: fields[1] as DateTime,
      isValid: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CacheSectionsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sections)
      ..writeByte(1)
      ..write(obj.lastFetchTime)
      ..writeByte(2)
      ..write(obj.isValid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheSectionsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
