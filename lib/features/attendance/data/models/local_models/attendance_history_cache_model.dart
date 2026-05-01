import 'package:hive/hive.dart';
import 'package:mobile_app/features/attendance/data/models/attendance_history_model.dart';

part 'attendance_history_cache_model.g.dart';

@HiveType(typeId: 12)
class AttendanceHistoryCacheModel extends HiveObject {
  @HiveField(0)
  final List<AttendanceHistoryModel> records;

  @HiveField(1)
  final DateTime cachedAt;

  AttendanceHistoryCacheModel({
    required this.records,
    required this.cachedAt,
  });
}