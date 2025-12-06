import 'dart:io';

import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/card_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/field_service_model.dart';
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
    print("✅ Card Detection Model loaded");
     await OcrService.initialize();
    print("✅ OCR Service initialized");
  }

  CameraController? get controller => _controller;

  @override
  Future<CapturedPhoto> capturePhoto() async {
    if (_controller == null || !_isCameraInitialized) {
      throw Exception("Camera not initialized");
    }
    
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
    
    print("🎯 Card Detection Result: ${result.isCardDetected}");
    print("   Label: ${result.label}");
    print("   Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%");
    
    return result.isCardDetected;
  }

  @override
  Future<List<DetectionModel>> detectFields(CapturedPhoto photo) async {
    if (!_fieldService.isLoaded) {
      print("🔄 Loading Field Detection Model...");
      await _fieldService.loadModel();
      print("✅ Field Detection Model loaded");
    }
    
    final detections = await ObjectDetectionService.detectFields(
      imagePath: photo.path,
      interpreterAddress: _fieldService.interpreterAddress,
      confidenceThreshold: 0.5,
    );
    
    return detections;
  }

  @override
  Future<List<CroppedField>> cropDetectedFields(
    CapturedPhoto photo,
    List<DetectionModel> detections,
  ) async {
    print("\n✂️ Cropping detected fields...");
    
    final croppedFields = await CropService.cropFields(
      originalImagePath: photo.path,
      detections: detections,
    );
    
    print("✅ Cropped ${croppedFields.length} fields\n");
    return croppedFields;
  }

   @override
  Future<Map<String, String>> extractTextFromFields(
    List<CroppedField> croppedFields,
  ) async {
    print("\n📝 Extracting text from cropped fields...");
    
    Map<String, String> extractedData = {};

    for (var field in croppedFields) {
      try {
        // Skip invalid fields
        if (field.fieldName.startsWith('invalid_')) {
          print("⏭️ Skipping invalid field: ${field.fieldName}");
          continue;
        }

        print("🔍 Processing: ${field.fieldName}");

        // Determine language based on field type
        String language = _getLanguageForField(field.fieldName);

        // Extract text
        final text = await OcrService.extractText(
          imageFile: File(field.imagePath),
          language: language,
          preprocessImage: true,
        );

        extractedData[field.fieldName] = text;
        print("✅ ${field.fieldName}: $text");
      } catch (e) {
        print("❌ Failed to extract text from ${field.fieldName}: $e");
        extractedData[field.fieldName] = '';
      }
    }

    print("\n✅ Text extraction complete: ${extractedData.length} fields processed\n");
    return extractedData;
  }

  /// Determine which language to use based on field name
  String _getLanguageForField(String fieldName) {
    // Fields that are typically in English
    if (fieldName.contains('nid') || 
        fieldName.contains('serial') || 
        fieldName.contains('expiry') ||
        fieldName.contains('issue') ||
        fieldName.contains('dob')) {
      return 'ara_number'; // Numbers and dates
    }
    
    // Arabic text fields
    return 'ara';
  }


  void close() {
    _controller?.dispose();
    _modelService.dispose();
    _fieldService.dispose();
  }
}