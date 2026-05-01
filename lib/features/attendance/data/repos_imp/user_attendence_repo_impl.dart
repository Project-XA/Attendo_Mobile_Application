import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_app/core/current_user/data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/features/attendance/data/data_source/attendance_local_data_source.dart';
import 'package:mobile_app/features/attendance/data/data_source/attendance_history_local_data_source.dart';
import 'package:mobile_app/features/attendance/data/services/attendence_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendence_reponse.dart';

class UserAttendanceRepositoryImpl implements UserAttendanceRepository {
  final AttendanceService _attendanceService;
  final DeviceInfoPlugin _deviceInfo;
  final UserRemoteDataSource userRemoteDataSource;
  final AttendanceLocalDataSource _localDataSource;
  final AttendanceHistoryLocalDataSource _historyLocalDataSource; 
  UserAttendanceRepositoryImpl({
    required AttendanceService attendanceService,
    required DeviceInfoPlugin deviceInfo,
    required this.userRemoteDataSource,
    required AttendanceLocalDataSource localDataSource,
    required AttendanceHistoryLocalDataSource historyLocalDataSource, 
  })  : _attendanceService = attendanceService,
        _deviceInfo = deviceInfo,
        _localDataSource = localDataSource,
        _historyLocalDataSource = historyLocalDataSource;

  @override
  Future<AttendanceStats?> getCachedStatsOnly() async {
    return await _localDataSource.getCachedStats();
  }

  @override
  Future<void> saveStatsToCache(AttendanceStats stats) async {
    await _localDataSource.cacheStats(stats);
  }

  @override
  Future<AttendanceResponse> checkIn({
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  }) async {
    try {
      final deviceHash = await _getDeviceHash();
      final response = await _attendanceService.sendAttendanceRequest(
        baseUrl: baseUrl,
        userId: userId,
        userName: userName,
        deviceIdHash: deviceHash,
      );

      if (response.success) {
        // Build the history record
        final record = AttendanceHistory(
          id: '${sessionId}_${DateTime.now().millisecondsSinceEpoch}',
          sessionId: sessionId,
          sessionName: 'attendance.fallback_session_name'.tr(),
          location: location ?? 'attendance.fallback_location_unknown'.tr(),
          checkInTime: DateTime.now(),
          status: AttendanceStatus.present, 
          lastUpdated: DateTime.now(),
        );

        await _historyLocalDataSource.addRecord(record);

        try {
          final updatedStats = await getAttendanceStats();
          await _localDataSource.cacheStats(updatedStats);
        } catch (_) {
          // Ignore cache update errors
        }
      }

      return response;
    } catch (e) {
      return AttendanceResponse(success: false, message: 'Network error: $e');
    }
  }

  @override
  Future<List<AttendanceHistory>> getAttendanceHistory() async {
    final cached = await _historyLocalDataSource.getHistory();
    return cached ?? [];
  }

  @override
  Future<AttendanceStats> getAttendanceStats() async {
    try {
      final statsResponse = await userRemoteDataSource.getUserStatistics();
      final freshStats = AttendanceStats(
        totalSessions: statsResponse.totalSessions,
        attendedSessions: statsResponse.attendedSessions,
        attendancePercentage: statsResponse.attendancePercentage,
      );
      await _localDataSource.cacheStats(freshStats);
      return freshStats;
    } catch (e) {
      final cachedStats = await _localDataSource.getCachedStats();
      if (cachedStats != null) return cachedStats;
      rethrow;
    }
  }

  Future<String> _getDeviceHash() async {
    try {
      String deviceId = '';
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }
      final bytes = utf8.encode(deviceId);
      final hash = sha256.convert(bytes);
      return hash.toString();
    } catch (e) {
      return 'unknown_device';
    }
  }
}