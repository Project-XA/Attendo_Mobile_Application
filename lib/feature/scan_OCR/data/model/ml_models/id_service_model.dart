import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/base_model.dart';

class IdServiceModel extends BaseModel {
  static final IdServiceModel _instance = IdServiceModel._internal();
  factory IdServiceModel() => _instance;
  IdServiceModel._internal();

  @override
  String get modelPath => "assets/models/detect_id_float32.tflite";
}
