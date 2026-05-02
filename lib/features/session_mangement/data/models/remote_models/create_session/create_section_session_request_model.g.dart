// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_section_session_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSectionSessionRequestModel _$CreateSectionSessionRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateSectionSessionRequestModel(
      organizationId: (json['organizationId'] as num).toInt(),
      sessionName: json['sessionName'] as String,
      createdBy: json['createdBy'] as String,
      sectionName: json['sectionName'] as String,
      connectionType: json['connectionType'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      allowedRadius: (json['allowedRadius'] as num).toDouble(),
      networkSSID: json['networkSSID'] as String,
      networkBSSID: json['networkBSSID'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      sectionId: (json['sectionId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateSectionSessionRequestModelToJson(
        CreateSectionSessionRequestModel instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'sessionName': instance.sessionName,
      'createdBy': instance.createdBy,
      'sectionName': instance.sectionName,
      'connectionType': instance.connectionType,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'allowedRadius': instance.allowedRadius,
      'networkSSID': instance.networkSSID,
      'networkBSSID': instance.networkBSSID,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'sectionId': instance.sectionId,
    };
