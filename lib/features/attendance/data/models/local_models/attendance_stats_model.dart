import 'package:hive/hive.dart';
import 'package:mobile_app/features/attendance/data/models/get-user-statistics/get_user_statisticts_response_model.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

part 'attendance_stats_model.g.dart';

@HiveType(typeId: 6)
class AttendanceStatsModel extends HiveObject {
  @HiveField(0)
  final int totalSessions;

  @HiveField(1)
  final int attendedSessions;

  @HiveField(2)
  final double attendancePercentage;

  @HiveField(3)
  final DateTime lastUpdated;

  AttendanceStatsModel({
    required this.totalSessions,
    required this.attendedSessions,
    required this.attendancePercentage,
    required this.lastUpdated,
  });

  AttendanceStats toEntity() {
    return AttendanceStats(
      totalSessions: totalSessions,
      attendedSessions: attendedSessions,
      attendancePercentage: attendancePercentage,
    );
  }

  factory AttendanceStatsModel.fromEntity(AttendanceStats stats) {
    return AttendanceStatsModel(
      totalSessions: stats.totalSessions,
      attendedSessions: stats.attendedSessions,
      attendancePercentage: stats.attendancePercentage,
      lastUpdated: DateTime.now(),
    );
  }

  // Create from API Model
  factory AttendanceStatsModel.fromApiModel(
    GetUserStatistictsResponseModel apiModel,
  ) {
    return AttendanceStatsModel(
      totalSessions: apiModel.totalSessions,
      attendedSessions: apiModel.attendedSessions,
      attendancePercentage: apiModel.attendancePercentage,
      lastUpdated: DateTime.now(),
    );
  }
}