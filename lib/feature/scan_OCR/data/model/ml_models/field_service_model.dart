import 'package:tflite_flutter/tflite_flutter.dart';

class FieldServiceModel {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;
  static final FieldServiceModel _instance = FieldServiceModel._internal();
  factory FieldServiceModel() => _instance;
  FieldServiceModel._internal();
  Future<void> loadModel({
    String modelPath = "assets/models/detect_odjects_float32.tflite",
  }) async {
    if (_isLoaded && _interpreter != null) {
      return;
    }

    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      final inputTensor = _interpreter!.getInputTensors().first;
      final outputTensor = _interpreter!.getOutputTensors().first;

      print("🔵 Fields Model Loaded Successfully!");
      print("📌 INPUT SHAPE  : ${inputTensor.shape}");
      print("📌 INPUT TYPE   : ${inputTensor.type}");
      print("📌 OUTPUT SHAPE : ${outputTensor.shape}");
      print("📌 OUTPUT TYPE  : ${outputTensor.type}");
      _isLoaded = true;
    } catch (e) {
      throw Exception("Failed to load model: $e");
    }
  }

  List<int> getInputShape() {
    _ensureModelLoaded();
    return _interpreter!.getInputTensor(0).shape;
  }

  void _ensureModelLoaded() {
    if (!_isLoaded || _interpreter == null) {
      throw Exception("Model not loaded. Call loadModel() first.");
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }

  int get interpreterAddress {
    _ensureModelLoaded();
    return _interpreter!.address;
  }

  bool get isLoaded => _isLoaded && _interpreter != null;
}
