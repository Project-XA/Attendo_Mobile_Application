import 'package:tflite_flutter/tflite_flutter.dart';

abstract class BaseModel {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  String get modelPath;

  BaseModel();

  Future<void> loadModel() async {
    if (_isLoaded && _interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isLoaded = true;
    } catch (e) {
      throw Exception("Failed to load model ($modelPath): $e");
    }
  }

  List<int> getInputShape() {
    _ensureLoaded();
    return _interpreter!.getInputTensor(0).shape;
  }

  List<int> getOutputShape() {
    _ensureLoaded();
    return _interpreter!.getOutputTensor(0).shape;
  }

  int get interpreterAddress {
    _ensureLoaded();
    return _interpreter!.address;
  }

  bool get isLoaded => _isLoaded && _interpreter != null;

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }

  void _ensureLoaded() {
    if (!_isLoaded || _interpreter == null) {
      throw Exception("Model not loaded. Call loadModel() first.");
    }
  }
}
