import 'package:mobile_app/features/ocr/data/model/ml_models/base_model.dart';

class FaceDetectionModel extends BaseModel {
  static final FaceDetectionModel _instance = FaceDetectionModel._internal();

  factory FaceDetectionModel() => _instance;

  FaceDetectionModel._internal();

  @override
  String get modelPath => 'assets/models/MediaPipeFaceDetector.tflite';
}
