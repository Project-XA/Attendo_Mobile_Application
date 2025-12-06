import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/card_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/field_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/object_detect_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/crop_service.dart';
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

  void close() {
    _controller?.dispose();
    _modelService.dispose();
    _fieldService.dispose();
  }
}