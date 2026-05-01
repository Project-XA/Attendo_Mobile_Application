import 'package:hive/hive.dart';

part 'attendance_history.g.dart';

class AttendanceHistory {
  final String id;
  final String sessionId;
  final String sessionName;
  final String location;
  final DateTime checkInTime;
  final AttendanceStatus status;
  final DateTime lastUpdated;

  AttendanceHistory({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.location,
    required this.checkInTime,
    required this.status,
    required this.lastUpdated,
  });
}

@HiveType(typeId: 11)
enum AttendanceStatus {
  @HiveField(0)
  present,
  @HiveField(1)
  late,
  @HiveField(2)
  absent,
}