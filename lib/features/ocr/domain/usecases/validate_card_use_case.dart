import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';

class ValidateCardUseCase {
  final CameraRepository _repository;

  ValidateCardUseCase(this._repository);

  Future<bool> execute(CapturedPhoto photo) async {
    return await _repository.isCard(photo);
  }
}