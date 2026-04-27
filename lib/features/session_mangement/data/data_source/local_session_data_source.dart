// local_session_data_source.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/cache_sections_data.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/hall_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/cache_halls_data.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/section_model.dart';

abstract class LocalSessionDataSource {
  Future<CacheHallsData?> getCachedHalls();
  Future<void> cacheHalls(List<HallModel> halls);
  Future<CacheSectionsData?> getCachedSections();
  Future<void> cacheSections(List<SectionModel> sections);
  Future<void> clearCache();
}

class LocalSessionDataSourceImpl implements LocalSessionDataSource {
  static const String _hallsBoxName = 'halls_cache_box';
  static const String _hallsCacheKey = 'cached_halls_data';

  static const String _sectionsBoxName = 'sections_cache_box';
  static const String _sectionsCacheKey = 'cached_sections_data';

  Box<CacheHallsData>? _hallsBox;
  Box<CacheSectionsData>? _sectionsBox;

  Future<void> _initHalls() async {
    if (_hallsBox == null || !_hallsBox!.isOpen) {
      _hallsBox = await Hive.openBox<CacheHallsData>(_hallsBoxName);
    }
  }

  Future<void> _initSections() async {
    if (_sectionsBox == null || !_sectionsBox!.isOpen) {
      _sectionsBox = await Hive.openBox<CacheSectionsData>(_sectionsBoxName);
    }
  }

  @override
  Future<CacheHallsData?> getCachedHalls() async {
    await _initHalls();
    return _hallsBox?.get(_hallsCacheKey);
  }

  @override
  Future<void> cacheHalls(List<HallModel> halls) async {
    await _initHalls();
    final cacheData = CacheHallsData(
      halls: halls,
      lastFetchTime: DateTime.now(),
      isValid: true,
    );
    await _hallsBox?.put(_hallsCacheKey, cacheData);
  }

  @override
  Future<CacheSectionsData?> getCachedSections() async {
    await _initSections();
    return _sectionsBox?.get(_sectionsCacheKey);
  }

  @override
  Future<void> cacheSections(List<SectionModel> sections) async {
    await _initSections();
    final cacheData = CacheSectionsData(
      sections: sections,
      lastFetchTime: DateTime.now(),
      isValid: true,
    );
    await _sectionsBox?.put(_sectionsCacheKey, cacheData);
  }

  @override
  Future<void> clearCache() async {
    await _initHalls();
    await _initSections();
    await _hallsBox?.clear();
    await _sectionsBox?.clear();
  }
}