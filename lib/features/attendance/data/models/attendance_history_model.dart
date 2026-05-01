import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';

part 'attendance_history_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class AttendanceHistoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sessionId;

  @HiveField(2)
  final String sessionName;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final DateTime checkInTime;

  @HiveField(5)
  final AttendanceStatus status;

  @HiveField(6)
  final DateTime lastUpdated;

  AttendanceHistoryModel({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.location,
    required this.checkInTime,
    required this.status,
    required this.lastUpdated,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceHistoryModelToJson(this);

  factory AttendanceHistoryModel.fromEntity(AttendanceHistory entity) {
    return AttendanceHistoryModel(
      id: entity.id,
      sessionId: entity.sessionId,
      sessionName: entity.sessionName,
      location: entity.location,
      checkInTime: entity.checkInTime,
      status: entity.status,
      lastUpdated: entity.lastUpdated,
    );
  }

  AttendanceHistory toEntity() {
    return AttendanceHistory(
      id: id,
      sessionId: sessionId,
      sessionName: sessionName,
      location: location,
      checkInTime: checkInTime,
      status: status,
      lastUpdated: lastUpdated,
    );
  }
}