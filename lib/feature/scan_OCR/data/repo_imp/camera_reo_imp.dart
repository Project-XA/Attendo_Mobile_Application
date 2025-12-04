import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/service_model.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/inference_service.dart';

class CameraRepImp implements CameraRepository {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  final ServiceModel _modelService = ServiceModel();

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

   
    return result.isCardDetected;
  }

  void close() {
    _controller?.dispose();
    _modelService.dispose();
  }
}