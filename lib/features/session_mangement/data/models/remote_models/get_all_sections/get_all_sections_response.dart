// get_all_sections_response.dart
import 'package:json_annotation/json_annotation.dart';
part 'get_all_sections_response.g.dart';

@JsonSerializable()
class GetAllSectionsResponse {
  final List<SectionInfo> sections;

  GetAllSectionsResponse({required this.sections});

  factory GetAllSectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllSectionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllSectionsResponseToJson(this);
}

@JsonSerializable()
class SectionInfo {
  @JsonKey(name: 'sectionId')
  final int id;

  @JsonKey(name: 'sectionName')
  final String sectionName;

  final int organizationId;

  SectionInfo({
    required this.id,
    required this.sectionName,
    required this.organizationId,
  });

  factory SectionInfo.fromJson(Map<String, dynamic> json) =>
      _$SectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SectionInfoToJson(this);
}