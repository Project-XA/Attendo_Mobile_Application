import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/processing_result_use_case.dart';

class ProcessCardUseCase {
  final CameraRepository _repository;

  ProcessCardUseCase(this._repository);

  Future<CardProcessingResult> execute(CapturedPhoto photo) async {
    final detections = await _repository.detectFields(photo);

    final croppedFields = await _repository.cropDetectedFields(
      photo,
      detections,
    );

    final finalData = await _repository.extractFinalData(croppedFields);

    return CardProcessingResult(
      croppedFields: croppedFields,
      finalData: finalData,
    );
  }
}