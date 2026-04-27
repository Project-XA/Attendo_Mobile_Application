// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_sections_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllSectionsResponse _$GetAllSectionsResponseFromJson(
        Map<String, dynamic> json) =>
    GetAllSectionsResponse(
      sections: (json['sections'] as List<dynamic>)
          .map((e) => SectionInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllSectionsResponseToJson(
        GetAllSectionsResponse instance) =>
    <String, dynamic>{
      'sections': instance.sections,
    };

SectionInfo _$SectionInfoFromJson(Map<String, dynamic> json) => SectionInfo(
      id: (json['sectionId'] as num).toInt(),
      sectionName: json['sectionName'] as String,
      organizationId: (json['organizationId'] as num).toInt(),
    );

Map<String, dynamic> _$SectionInfoToJson(SectionInfo instance) =>
    <String, dynamic>{
      'sectionId': instance.id,
      'sectionName': instance.sectionName,
      'organizationId': instance.organizationId,
    };
