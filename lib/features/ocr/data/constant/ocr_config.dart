// data/constant/ocr_config.dart
import 'ocr_constants.dart';

class OcrConfig {
  // Thresholds
  final double cardThreshold;
  final double fieldThreshold;
  final double digitThreshold;
  final double nmsThreshold;

  // Required/Invalid labels
  final List<String> requiredLabels;
  final List<String> invalidLabels;

  const OcrConfig({
    this.cardThreshold = OcrConstants.cardDetectionThreshold,
    this.fieldThreshold = OcrConstants.fieldDetectionThreshold,
    this.digitThreshold = OcrConstants.digitRecognitionThreshold,
    this.nmsThreshold = OcrConstants.nmsIouThreshold,
    this.requiredLabels = const ['photo', 'firstName', 'lastName'],
    this.invalidLabels = const [
      'invalid_address', 'invalid_barcode', 'invalid_demo',
      'invalid_dob', 'invalid_expiry', 'invalid_firstName',
      'invalid_issue', 'invalid_job', 'invalid_lastName',
      'invalid_logo', 'invalid_nid', 'invalid_nid_back',
      'invalid_photo', 'invalid_poe', 'invalid_serial',
      'invalid_watermark_tut',
    ],
  });

  static const OcrConfig defaultConfig = OcrConfig();
}