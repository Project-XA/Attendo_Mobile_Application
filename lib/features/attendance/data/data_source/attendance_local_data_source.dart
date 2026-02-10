import 'package:hive/hive.dart';
import 'package:mobile_app/features/attendance/data/models/local_models/attendance_stats_model.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

abstract class AttendanceLocalDataSource {
  Future<AttendanceStats?> getCachedStats();
  Future<void> cacheStats(AttendanceStats stats);
  Future<void> clearCache();
  Future<bool> isCacheValid();
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  static const String _boxName = 'attendance_stats';
  static const String _statsKey = 'user_stats';
  static const Duration _cacheValidDuration = Duration(hours: 1);

  Box<AttendanceStatsModel>? _box;

  Future<Box<AttendanceStatsModel>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await Hive.openBox<AttendanceStatsModel>(_boxName);
    return _box!;
  }

  @override
  Future<AttendanceStats?> getCachedStats() async {
    try {
      final box = await _getBox();
      final cachedModel = box.get(_statsKey);
      
      if (cachedModel == null) {
        return null;
      }

      // Check if cache is still valid
      final isValid = await isCacheValid();
      if (!isValid) {
        await clearCache();
        return null;
      }

      return cachedModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheStats(AttendanceStats stats) async {
    try {
      final box = await _getBox();
      final model = AttendanceStatsModel.fromEntity(stats);
      await box.put(_statsKey, model);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBox();
      await box.delete(_statsKey);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final box = await _getBox();
      final cachedModel = box.get(_statsKey);
      
      if (cachedModel == null) {
        return false;
      }

      final now = DateTime.now();
      final difference = now.difference(cachedModel.lastUpdated);
      
      return difference < _cacheValidDuration;
    } catch (e) {
      return false;
    }
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}