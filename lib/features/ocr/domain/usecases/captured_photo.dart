import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';

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
