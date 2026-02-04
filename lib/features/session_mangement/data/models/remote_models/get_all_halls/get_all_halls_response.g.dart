// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_halls_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllHallsResponse _$GetAllHallsResponseFromJson(Map<String, dynamic> json) =>
    GetAllHallsResponse(
      halls: (json['halls'] as List<dynamic>)
          .map((e) => HallInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllHallsResponseToJson(
        GetAllHallsResponse instance) =>
    <String, dynamic>{
      'halls': instance.halls,
    };

HallInfo _$HallInfoFromJson(Map<String, dynamic> json) => HallInfo(
      id: (json['id'] as num).toInt(),
      hallName: json['hallName'] as String,
      capacity: (json['capacity'] as num).toInt(),
      hallArea: (json['hallArea'] as num).toDouble(),
      organizationId: (json['organizationId'] as num).toInt(),
    );

Map<String, dynamic> _$HallInfoToJson(HallInfo instance) => <String, dynamic>{
      'id': instance.id,
      'hallName': instance.hallName,
      'capacity': instance.capacity,
      'hallArea': instance.hallArea,
      'organizationId': instance.organizationId,
    };
