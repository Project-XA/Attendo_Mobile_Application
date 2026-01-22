import 'package:mobile_app/features/ocr/data/model/ml_models/base_model.dart';

class FieldServiceModel extends BaseModel {
  static final FieldServiceModel _instance = FieldServiceModel._internal();
  factory FieldServiceModel() => _instance;
  FieldServiceModel._internal();

  @override
  String get modelPath => "assets/models/detect_odjects_float32.tflite";
}
