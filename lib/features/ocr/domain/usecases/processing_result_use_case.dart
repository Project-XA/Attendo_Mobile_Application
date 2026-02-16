// processing_result_use_case.dart
import 'package:mobile_app/features/ocr/data/model/cropped_field.dart';
import 'package:mobile_app/features/ocr/domain/entities/extracted_id_card_data.dart';

class CardProcessingResult {
  final List<CroppedField> croppedFields;
  final Map<String, String> rawData;        // ✅ احتفظ بيه للـ backward compat
  final ExtractedIdCardData extractedData;  // ✅ الجديد

  CardProcessingResult({
    required this.croppedFields,
    required this.rawData,
  }) : extractedData = ExtractedIdCardData.fromMap(rawData);

  Map<String, String> get finalData => rawData;
}