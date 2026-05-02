import 'package:json_annotation/json_annotation.dart';
part 'create_section_session_request_model.g.dart';

@JsonSerializable()
class CreateSectionSessionRequestModel {
  final int organizationId;
  final String sessionName;
  final String createdBy;
  final String sectionName;
  final String connectionType;
  final double longitude;
  final double latitude;
  final double allowedRadius;
  final String networkSSID;
  final String networkBSSID;
  final String startAt;
  final String endAt;
  final int sectionId;

  CreateSectionSessionRequestModel({
    required this.organizationId,
    required this.sessionName,
    required this.createdBy,
    required this.sectionName,
    required this.connectionType,
    required this.longitude,
    required this.latitude,
    required this.allowedRadius,
    required this.networkSSID,
    required this.networkBSSID,
    required this.startAt,
    required this.endAt,
    required this.sectionId,
  });

  factory CreateSectionSessionRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateSectionSessionRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$CreateSectionSessionRequestModelToJson(this);
}
