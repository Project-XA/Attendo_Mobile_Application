// section_model.dart
import 'package:hive/hive.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
part 'section_model.g.dart';

@HiveType(typeId: 8)
class SectionModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String sectionName;

  @HiveField(2)
  final int organizationId;

  SectionModel({
    required this.id,
    required this.sectionName,
    required this.organizationId,
  });

  factory SectionModel.fromSectionInfo(SectionInfo sectionInfo) {
    return SectionModel(
      id: sectionInfo.id,
      sectionName: sectionInfo.sectionName,
      organizationId: sectionInfo.organizationId,
    );
  }

  SectionInfo toSectionInfo() {
    return SectionInfo(
      id: id,
      sectionName: sectionName,
      organizationId: organizationId,
    );
  }
}