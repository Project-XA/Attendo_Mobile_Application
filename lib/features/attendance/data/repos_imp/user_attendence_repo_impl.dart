import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_app/core/curren_user/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/features/attendance/data/models/attendence_history_model.dart';
import 'package:mobile_app/features/attendance/data/services/attendence_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendence_reponse.dart';

class UserAttendanceRepositoryImpl implements UserAttendanceRepository {
  final AttendanceService _attendanceService;
  final DeviceInfoPlugin _deviceInfo;
  final UserRemoteDataSource userRemoteDataSource;
  final List<AttendanceHistoryModel> _historyCache = [];

  UserAttendanceRepositoryImpl({
  
    required AttendanceService attendanceService,
    required DeviceInfoPlugin deviceInfo,
    required this.userRemoteDataSource,
  })  : _attendanceService = attendanceService,
        _deviceInfo = deviceInfo;

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
        _historyCache.add(AttendanceHistoryModel(
          id: '${sessionId}_${DateTime.now().millisecondsSinceEpoch}',
          sessionId: sessionId,
          sessionName: 'Session',
          location: location ?? 'Unknown',
          checkInTime: DateTime.now(),
          status: 'present',
        ));
      }
      
      return response;
    } catch (e) {
      return AttendanceResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  @override
  Future<List<AttendanceHistory>> getAttendanceHistory() async {
    return _historyCache.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AttendanceStats> getAttendanceStats() async {
    try {
      final statsResponse = await userRemoteDataSource.getUserStatistics();
      return AttendanceStats(
        totalSessions: statsResponse.totalSessions,
        attendedSessions: statsResponse.attendedSessions,
        attendancePercentage: statsResponse.attendancePercentage,
      );
    } catch (e) {
      return AttendanceStats(
        totalSessions: 0,
        attendedSessions: 0,
        attendancePercentage: 0.0,
      );
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