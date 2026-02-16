import 'package:mobile_app/features/ocr/data/model/ml_models/card_service_model.dart';
import 'package:mobile_app/features/ocr/data/model/ml_models/field_service_model.dart';
import 'package:mobile_app/features/ocr/data/model/ml_models/id_service_model.dart';
import 'package:mobile_app/features/ocr/data/services/ocr_service.dart';


class InitializeOcrUseCase {
  final CardServiceModel _cardModel;
  final FieldServiceModel _fieldModel;
  final IdServiceModel _idModel;

  InitializeOcrUseCase({
    CardServiceModel? cardModel,
    FieldServiceModel? fieldModel,
    IdServiceModel? idModel,
  })  : _cardModel = cardModel ?? CardServiceModel(),
        _fieldModel = fieldModel ?? FieldServiceModel(),
        _idModel = idModel ?? IdServiceModel();

  Future<void> execute() async {
    await OcrService.initialize();

    await _cardModel.loadModel();
    await _fieldModel.loadModel();
    await _idModel.loadModel();
  }
}

