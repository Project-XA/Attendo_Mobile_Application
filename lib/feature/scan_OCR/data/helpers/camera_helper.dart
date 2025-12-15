import 'package:camera/camera.dart';

class CameraHelper {
  static CameraHelper? _instance;
  static CameraHelper get instance => _instance ??= CameraHelper._();
  
  CameraHelper._();

  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isInitializing = false;

  Future<List<CameraDescription>> getCameras() async {
    if (_isInitialized && _cameras != null) {
      return _cameras!;
    }

    if (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 100));
      return getCameras(); 
    }

    try {
      _isInitializing = true;
      _cameras = await availableCameras();
      _isInitialized = true;
      return _cameras!;
    } catch (e) {
      print('Error initializing cameras: $e');
      return [];
    } finally {
      _isInitializing = false;
    }
  }

  void dispose() {
    _cameras = null;
    _isInitialized = false;
    _isInitializing = false;
  }

  Future<void> preInitialize() async {
    if (!_isInitialized && !_isInitializing) {
      getCameras();
    }
  }
}
