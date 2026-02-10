import 'package:json_annotation/json_annotation.dart';

part 'get_all_halls_response.g.dart';

@JsonSerializable()
class GetAllHallsResponse {
  final List<HallInfo> halls;

  GetAllHallsResponse({required this.halls});
  factory GetAllHallsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllHallsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllHallsResponseToJson(this);
}

@JsonSerializable()
class HallInfo {
  final int id;
  final String hallName;
  final int capacity;
  final double hallArea;
  final int organizationId;
  HallInfo({
    required this.id,
    required this.hallName,
    required this.capacity,
    required this.hallArea,
    required this.organizationId,
  });
  factory HallInfo.fromJson(Map<String, dynamic> json) =>
      _$HallInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HallInfoToJson(this);
}
