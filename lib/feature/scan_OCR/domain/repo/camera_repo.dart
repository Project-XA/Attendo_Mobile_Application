import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

abstract class CameraRepository {
  Future<CapturedPhoto> capturePhoto();
  Future<void> openCamera();
  Future<bool> isCard(CapturedPhoto photo);
   Future<List<Map<String, dynamic>>> detectFields(CapturedPhoto photo);
}
