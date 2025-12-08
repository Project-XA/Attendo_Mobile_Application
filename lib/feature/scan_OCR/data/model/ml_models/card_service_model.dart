import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/base_model.dart';


class CardServiceModel extends BaseModel {
  static final CardServiceModel _instance = CardServiceModel._internal();
  factory CardServiceModel() => _instance;
  CardServiceModel._internal();

  @override
  String get modelPath => "assets/models/detect_id_card_float32.tflite";
}
