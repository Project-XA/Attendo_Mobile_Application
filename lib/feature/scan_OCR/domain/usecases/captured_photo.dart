import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';

class CapturedPhoto {
  final String path;
  CapturedPhoto({required this.path});
}


class CapturePhotoUseCase {
  final CameraRepository _repository;

  CapturePhotoUseCase(this._repository);

  Future<CapturedPhoto> execute() async {
    return await _repository.capturePhoto();
  }
}


class ValidateCardUseCase {
  final CameraRepository _repository;

  ValidateCardUseCase(this._repository);

  Future<bool> execute(CapturedPhoto photo) async {
    return await _repository.isCard(photo);
  }
}

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
class CardProcessingResult {
  final List<CroppedField> croppedFields;
  final Map<String, String> finalData;

  CardProcessingResult({
    required this.croppedFields,
    required this.finalData,
  });
}