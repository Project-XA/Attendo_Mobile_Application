import 'package:mobile_app/features/ocr/data/constant/ocr_config.dart';
import 'package:mobile_app/features/ocr/data/model/detection_model.dart';

class ValidateRequiredFieldsUseCase {
  final OcrConfig _config;


  ValidateRequiredFieldsUseCase({ OcrConfig config=OcrConfig.defaultConfig}) : _config = config;

  Future<ValidationResult> execute(List<DetectionModel> detections) async {
    try {
      if (detections.isEmpty) {
        return ValidationResult(
          isValid: false,
          missingFields: _config.requiredLabels,
          reason: 'No fields detected',
        );
      }

      final invalidDetections = detections
          .where((d) => _config.invalidLabels.contains(d.className))
          .toList();

      if (invalidDetections.isNotEmpty) {
        return ValidationResult(
          isValid: false,
          invalidFields: invalidDetections.map((d) => d.className).toList(),
          reason:
              'Invalid fields detected: ${invalidDetections.map((d) => d.className).join(", ")}',
        );
      }

      final detectedLabels = detections
          .map((detection) => detection.className)
          .toSet();

      final missingLabels = _config.requiredLabels
          .where((label) => !detectedLabels.contains(label))
          .toList();

      if (missingLabels.isNotEmpty) {
        return ValidationResult(
          isValid: false,
          missingFields: missingLabels,
          detectedFields: detectedLabels.toList(),
          reason: 'Missing required fields: ${missingLabels.join(", ")}',
        );
      }

      final lowConfidenceFields = <String>[];

      for (final requiredLabel in _config.requiredLabels) {
        final detection = detections.firstWhere(
          (d) => d.className == requiredLabel,
        );

        if (detection.confidence < 0.5) {
          lowConfidenceFields.add(
            '$requiredLabel (${(detection.confidence * 100).toStringAsFixed(1)}%)',
          );
        }
      }

      if (lowConfidenceFields.isNotEmpty) {
        return ValidationResult(
          isValid: false,
          lowConfidenceFields: lowConfidenceFields,
          reason: 'Low confidence in fields: ${lowConfidenceFields.join(", ")}',
        );
      }

      return ValidationResult(
        isValid: true,
        detectedFields: detectedLabels.toList(),
        reason: 'All required fields detected',
      );
    } catch (e) {
      return ValidationResult(isValid: false, reason: 'Validation error: $e');
    }
  }
}

class ValidationResult {
  final bool isValid;
  final List<String>? missingFields;
  final List<String>? invalidFields;
  final List<String>? lowConfidenceFields;
  final List<String>? detectedFields;
  final String reason;

  ValidationResult({
    required this.isValid,
    this.missingFields,
    this.invalidFields,
    this.lowConfidenceFields,
    this.detectedFields,
    required this.reason,
  });

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, reason: $reason)';
  }
}
