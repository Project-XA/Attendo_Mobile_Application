import 'package:hive/hive.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
part 'hall_model.g.dart';

@HiveType(typeId: 4)
class HallModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String hallName;

  @HiveField(2)
  final int capacity;

  @HiveField(3)
  final double hallArea;

  @HiveField(4)
  final int organizationId;

  HallModel({
    required this.id,
    required this.hallName,
    required this.capacity,
    required this.hallArea,
    required this.organizationId,
  });

  factory HallModel.fromHallInfo(HallInfo hallInfo) {
    return HallModel(
      id: hallInfo.id,
      hallName: hallInfo.hallName,
      capacity: hallInfo.capacity,
      hallArea: hallInfo.hallArea,
      organizationId: hallInfo.organizationId,
    );
  }

  HallInfo toHallInfo() {
    return HallInfo(
      id: id,
      hallName: hallName,
      capacity: capacity,
      hallArea: hallArea,
      organizationId: organizationId,
    );
  }
}
