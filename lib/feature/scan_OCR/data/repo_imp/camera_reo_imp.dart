// Cleaned version without print statements
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/card_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/id_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/field_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/ocr_repo_imp.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/digital_recognition_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/object_detect_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/crop_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/ocr_service.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/inference_service.dart';

class CameraRepImp implements CameraRepository {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  final CardServiceModel _modelService = CardServiceModel();
  final FieldServiceModel _fieldService = FieldServiceModel();
  final IdServiceModel _idService = IdServiceModel();
  final OcrRepoImpl _ocrRepo = OcrRepoImpl();

  @override
  Future<void> openCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.first;

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isCameraInitialized = true;
    await _modelService.loadModel();
    await OcrService.initialize();
  }

  @override
  Future<void> closeCamera() async {
    await _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  CameraController? get controller => _controller;

  @override
  Future<CapturedPhoto> capturePhoto() async {
    if (_controller == null || !_isCameraInitialized) {
      throw Exception("Camera not initialized");
    }

    try {
      await _controller?.stopImageStream();
      await _controller?.pausePreview();
    } catch (_) {}

    final file = await _controller!.takePicture();
    return CapturedPhoto(path: file.path);
  }

  @override
  Future<bool> isCard(CapturedPhoto photo) async {
    if (!_modelService.isLoaded) {
      await _modelService.loadModel();
    }

    final result = await InferenceService.detectCard(
      imagePath: photo.path,
      interpreterAddress: _modelService.interpreterAddress,
      confidenceThreshold: 0.3,
    );

    return result.isCardDetected;
  }

  @override
  Future<List<DetectionModel>> detectFields(CapturedPhoto photo) async {
    if (!_fieldService.isLoaded) {
      await _fieldService.loadModel();
    }

    return await ObjectDetectionService.detectFields(
      imagePath: photo.path,
      interpreterAddress: _fieldService.interpreterAddress,
      confidenceThreshold: 0.5,
    );
  }

  @override
  Future<List<CroppedField>> cropDetectedFields(
    CapturedPhoto photo,
    List<DetectionModel> detections,
  ) async {
    return await CropService.cropFields(
      originalImagePath: photo.path,
      detections: detections,
    );
  }

  @override
  Future<Map<String, String>> extractTextFromFields(
    List<CroppedField> croppedFields,
  ) async {
    Map<String, String> extractedData = {};

    for (var field in croppedFields) {
      try {
        if (field.fieldName.startsWith('invalid_')) continue;

        String language = _getLanguageForField(field.fieldName);
        final text = await OcrService.extractText(
          imageFile: File(field.imagePath),
          language: language,
          preprocessImage: true,
        );

        extractedData[field.fieldName] = text;
      } catch (e) {
        extractedData[field.fieldName] = '';
      }
    }

    return extractedData;
  }

  @override
  Future<Map<String, String>> extractFinalData(
    List<CroppedField> croppedFields,
  ) async {
    if (!_idService.isLoaded) {
      await _idService.loadModel();
    }

    Map<String, String> finalData = {};

    for (var field in croppedFields) {
      try {
        if (field.fieldName.startsWith('invalid_')) continue;

        String fieldType = _getFieldType(field.fieldName);

        if (fieldType == 'nid' || fieldType == 'model3') {
          final digits = await DigitRecognitionService.extractDigits(
            imagePath: field.imagePath,
            interpreterAddress: _idService.interpreterAddress,
            confidenceThreshold: 0.1,
          );
          finalData[field.fieldName] = digits;
        } else {
          final text = await OcrService.extractText(
            imageFile: File(field.imagePath),
            language: 'ara',
            preprocessImage: true,
          );
          finalData[field.fieldName] = text;
        }
      } catch (e) {
        finalData[field.fieldName] = '';
      }
    }

    return finalData;
  }

  String _getLanguageForField(String name) {
    return name.contains("serial") ||
            name.contains("dob") ||
            name.contains("expiry")
        ? 'ara_number'
        : 'ara';
  }

  String _getFieldType(String fieldName) {
    if (fieldName == 'nid') return 'nid';
    if (fieldName.contains('serial') ||
        fieldName.contains('dob') ||
        fieldName.contains('expiry') ||
        fieldName.contains('issue')) {
      return 'model3';
    }
    return 'text';
  }

  
}
