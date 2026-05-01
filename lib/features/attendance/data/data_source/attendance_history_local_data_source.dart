import 'package:hive/hive.dart';
import 'package:mobile_app/features/attendance/data/models/attendance_history_model.dart';
import 'package:mobile_app/features/attendance/data/models/local_models/attendance_history_cache_model.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';

abstract class AttendanceHistoryLocalDataSource {
  Future<void> saveHistory(List<AttendanceHistory> history);
  Future<void> addRecord(AttendanceHistory record); // ← new
  Future<List<AttendanceHistory>?> getHistory();
  Future<void> clearHistory();
  Future<bool> isCacheValid();
}

class AttendanceHistoryLocalDataSourceImpl
    extends AttendanceHistoryLocalDataSource {
  static const String _boxName = 'attendance_history';
  static const String _historyKey = 'user_attendance_history';
  static const Duration _cacheValidDuration = Duration(hours: 1);

  Box<AttendanceHistoryCacheModel>? _box;

  Future<Box<AttendanceHistoryCacheModel>> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox<AttendanceHistoryCacheModel>(_boxName);
    return _box!;
  }

  /// Adds a single record to the existing cached list.
  /// If no cache exists yet, creates a fresh one with just this record.
  @override
  Future<void> addRecord(AttendanceHistory record) async {
    final box = await _getBox();
    final existing = box.get(_historyKey);

    final updatedRecords = [
      // Prepend new record so the latest always appears first
      AttendanceHistoryModel.fromEntity(record),
      if (existing != null) ...existing.records,
    ];

    final updatedCache = AttendanceHistoryCacheModel(
      records: updatedRecords,
      cachedAt: existing?.cachedAt ?? DateTime.now(),
      // ↑ keep the original cachedAt so the 1-hour window isn't reset
      // on every check-in — only a full saveHistory() resets it.
    );

    await box.put(_historyKey, updatedCache);
  }

  @override
  Future<void> saveHistory(List<AttendanceHistory> history) async {
    final box = await _getBox();
    final cacheModel = AttendanceHistoryCacheModel(
      records: history.map(AttendanceHistoryModel.fromEntity).toList(),
      cachedAt: DateTime.now(),
    );
    await box.put(_historyKey, cacheModel);
  }

  @override
  Future<List<AttendanceHistory>?> getHistory() async {
    try {
      final box = await _getBox();
      final cached = box.get(_historyKey);

      if (cached == null) return null;

      final isValid = await isCacheValid();
      if (!isValid) {
        await clearHistory();
        return null;
      }

      return cached.records.map((model) => model.toEntity()).toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearHistory() async {
    final box = await _getBox();
    await box.delete(_historyKey);
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final box = await _getBox();
      final cached = box.get(_historyKey);
      if (cached == null) return false;
      final difference = DateTime.now().difference(cached.cachedAt);
      return difference < _cacheValidDuration;
    } catch (_) {
      return false;
    }
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
