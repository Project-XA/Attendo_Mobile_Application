import 'package:mobile_app/feature/scan_OCR/data/model/bounding_box.dart';

class CroppedField {
  final String fieldName;
  final double confidence;
  final String imagePath;
  final BoundingBox bbox;

  CroppedField({
    required this.fieldName,
    required this.confidence,
    required this.imagePath,
    required this.bbox,
  });
}