import 'package:tflite_flutter/tflite_flutter.dart';

class ServiceModel {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;

  static final ServiceModel _instance = ServiceModel._internal();
  factory ServiceModel() => _instance;
  ServiceModel._internal();

  Future<void> loadModel({String modelPath = "assets/detect_id_card_float32.tflite"}) async {
    if (_isLoaded && _interpreter != null) {
      return;
    }

    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isLoaded = true;
    } catch (e) {
      throw Exception("Failed to load model: $e");
    }
  }

  List<int> getInputShape() {
    _ensureModelLoaded();
    return _interpreter!.getInputTensor(0).shape;
  }

  List<int> getOutputShape() {
    _ensureModelLoaded();
    return _interpreter!.getOutputTensor(0).shape;
  }

  int get interpreterAddress {
    _ensureModelLoaded();
    return _interpreter!.address;
  }

  bool get isLoaded => _isLoaded && _interpreter != null;

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }

  
  void _ensureModelLoaded() {
    if (!_isLoaded || _interpreter == null) {
      throw Exception("Model not loaded. Call loadModel() first.");
    }
  }
}