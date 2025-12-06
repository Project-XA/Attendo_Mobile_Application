import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

abstract class CameraRepository {
  Future<CapturedPhoto> capturePhoto();
  Future<void> openCamera();
  Future<bool> isCard(CapturedPhoto photo);
  Future<List<DetectionModel>> detectFields(CapturedPhoto photo);
  Future<List<CroppedField>> cropDetectedFields(
    CapturedPhoto photo,
    List<DetectionModel> detections,
  );
}
