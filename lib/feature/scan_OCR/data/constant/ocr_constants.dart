class OcrConstants {
  static const double cardDetectionThreshold = 0.3;
  static const double fieldDetectionThreshold = 0.5;
  static const double digitRecognitionThreshold = 0.1;
  static const double nmsIouThreshold = 0.5;

  static const int modelInputWidth = 640;
  static const int modelInputHeight = 640;
  static const int yoloOutputSize = 8400;

  static const String arabicLanguage = 'ara';
  static const String englishLanguage = 'eng';
  static const String arabicNumberLanguage = 'ara_number';
  static const String combinedLanguage = 'ara+eng';

  static const String defaultPsmMode = '6';

  static const String cardModelPath =
      "assets/models/detect_id_card_float32.tflite";
  static const String fieldModelPath =
      "assets/models/detect_odjects_float32.tflite";
  static const String idModelPath = "assets/models/detect_id_float32.tflite";

  static const List<String> tessdataFiles = [
    'ara.traineddata',
    'eng.traineddata',
    'ara_combined.traineddata',
    'ara_number.traineddata',
  ];

  static const bool cameraAudioEnabled = false;

  OcrConstants._();
}
