import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/hall_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/cache_halls_data.dart';

abstract class LocalSessionDataSource {
  Future<CacheHallsData?> getCachedHalls();
  Future<void> cacheHalls(List<HallModel> halls);
  Future<void> clearCache();
}

class LocalSessionDataSourceImpl implements LocalSessionDataSource {
  static const String _hallsBoxName = 'halls_cache_box';
  static const String _cacheKey = 'cached_halls_data';

  Box<CacheHallsData>? _box;

  Future<void> _init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<CacheHallsData>(_hallsBoxName);
    }
  }

  @override
  Future<CacheHallsData?> getCachedHalls() async {
    await _init();
    return _box?.get(_cacheKey);
  }

  @override
  Future<void> cacheHalls(List<HallModel> halls) async {
    await _init();

    final cacheData = CacheHallsData(
      halls: halls,
      lastFetchTime: DateTime.now(),
      isValid: true,
    );

    await _box?.put(_cacheKey, cacheData);
  }

  @override
  Future<void> clearCache() async {
    await _init();
    await _box?.clear();
  }
}
