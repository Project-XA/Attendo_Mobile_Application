import 'package:json_annotation/json_annotation.dart';
part 'create_session_request_section_model.g.dart';

@JsonSerializable()
class CreateSessionRequestSectionModel {
  final int organizationId;
  final String sessionName;
  final String createdBy;
  final String hallName;
  final String connectionType;
  final double longitude;
  final double latitude;
  final double allowedRadius;
  final String networkSSID;
  final String networkBSSID;
  final String startAt;
  final String endAt;
  final int sectionId;

  CreateSessionRequestSectionModel({
    required this.organizationId,
    required this.sessionName,
    required this.createdBy,
    required this.hallName,
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

  factory CreateSessionRequestSectionModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionRequestSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSessionRequestSectionModelToJson(this);
}
