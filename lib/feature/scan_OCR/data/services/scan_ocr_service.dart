import 'dart:io';
import '../model/cropped_field.dart';
import '../model/detection_model.dart';
import '../model/ml_models/card_service_model.dart';
import '../model/ml_models/field_service_model.dart';
import '../model/ml_models/id_service_model.dart';
import '../services/crop_service.dart';
import '../services/ocr_service.dart';
import '../services/object_detect_service.dart';
import '../services/digital_recognition_service.dart';
import '../services/inference_service.dart';

class ScanOcrService {
  final CardServiceModel cardModel = CardServiceModel();
  final FieldServiceModel fieldModel = FieldServiceModel();
  final IdServiceModel idModel = IdServiceModel();

  Future<bool> isCard(String path) async {
    await cardModel.loadModel();
    final result = await InferenceService.detectCard(
      imagePath: path,
      interpreterAddress: cardModel.interpreterAddress,
      confidenceThreshold: 0.3,
    );
    return result.isCardDetected;
  }

  Future<List<DetectionModel>> detectFields(String path) async {
    await fieldModel.loadModel();
    return ObjectDetectionService.detectFields(
      imagePath: path,
      interpreterAddress: fieldModel.interpreterAddress,
      confidenceThreshold: 0.5,
    );
  }

  Future<List<CroppedField>> crop(String path, List<DetectionModel> d) async {
    return CropService.cropFields(
      originalImagePath: path,
      detections: d,
    );
  }

  Future<Map<String, String>> extractText(List<CroppedField> fields) async {
    Map<String, String> out = {};

    for (var f in fields) {
      if (f.fieldName.startsWith('invalid_')) continue;

      final lang = _getLang(f.fieldName);
      final text = await OcrService.extractText(
        imageFile: File(f.imagePath),
        language: lang,
        preprocessImage: true,
      );

      out[f.fieldName] = text;
    }
    return out;
  }

  Future<Map<String, String>> extractFinalData(List<CroppedField> fields) async {
    await idModel.loadModel();

    Map<String, String> data = {};

    for (var f in fields) {
      if (f.fieldName.startsWith('invalid_')) continue;

      final type = _getType(f.fieldName);

      if (type == "model3" || type == "nid") {
        final digits = await DigitRecognitionService.extractDigits(
          imagePath: f.imagePath,
          interpreterAddress: idModel.interpreterAddress,
          confidenceThreshold: 0.1,
        );
        data[f.fieldName] = digits;
      } else {
        final text = await OcrService.extractText(
          imageFile: File(f.imagePath),
          language: "ara",
          preprocessImage: true,
        );
        data[f.fieldName] = text;
      }
    }
    return data;
  }

  String _getLang(name) =>
      name.contains("serial") || name.contains("dob") || name.contains("expiry")
          ? "ara_number"
          : "ara";

  String _getType(name) {
    if (name == "nid") return "nid";
    if (name.contains("serial") ||
        name.contains("dob") ||
        name.contains("expiry") ||
        name.contains("issue")) return "model3";
    return "text";
  }
}
