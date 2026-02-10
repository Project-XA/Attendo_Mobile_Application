import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/hall_model.dart';

part 'cache_halls_data.g.dart';
@HiveType(typeId: 5)
class CacheHallsData extends HiveObject {
  @HiveField(0)
  final List<HallModel> halls;

  @HiveField(1)
  final DateTime lastFetchTime;

  @HiveField(2)
  final bool isValid;

  CacheHallsData({
    required this.lastFetchTime,
    required this.isValid,
    required this.halls,
  });

  bool shouldRefresh({int cacheMinutes = 10}) {
    return DateTime.now().difference(lastFetchTime).inMinutes > cacheMinutes;
  }
}
