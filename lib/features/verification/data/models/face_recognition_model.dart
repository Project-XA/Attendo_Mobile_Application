import 'package:mobile_app/features/ocr/data/model/ml_models/base_model.dart';

class FaceRecognitionModel extends BaseModel {
  static final FaceRecognitionModel _instance = FaceRecognitionModel._internal();
  
  factory FaceRecognitionModel() => _instance;
  
  FaceRecognitionModel._internal();
  
  @override
  String get modelPath => 'assets/models/mobilefacenet.tflite';
}