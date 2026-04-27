// cache_sections_data.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/section_model.dart';
part 'cache_sections_data.g.dart';

@HiveType(typeId: 7)
class CacheSectionsData extends HiveObject {
  @HiveField(0)
  final List<SectionModel> sections;

  @HiveField(1)
  final DateTime lastFetchTime;

  @HiveField(2)
  final bool isValid;

  CacheSectionsData({
    required this.sections,
    required this.lastFetchTime,
    required this.isValid,
  });

  bool shouldRefresh({int cacheMinutes = 10}) {
    return DateTime.now().difference(lastFetchTime).inMinutes > cacheMinutes;
  }
}