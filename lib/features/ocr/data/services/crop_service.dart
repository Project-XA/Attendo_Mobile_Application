import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:mobile_app/features/ocr/data/model/bounding_box.dart';
import 'package:mobile_app/features/ocr/data/model/cropped_field.dart';
import 'package:mobile_app/features/ocr/data/model/detection_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


/*
this service takes the original image path and a list of detections (each containing normalized coordinates,
class name, and confidence) and crops the relevant fields from the original image.
It saves each cropped field as a separate image file and returns a list of CroppedField objects containing the field name,
confidence, image path, and bounding box information.
*/ 
class CropService {
  static Future<List<CroppedField>> cropFields({
    required String originalImagePath,
    required List<DetectionModel> detections,
  }) async {
    try {
      final imageBytes = await File(originalImagePath).readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        throw Exception("Failed to decode image");
      }

      final originalWidth = originalImage.width;
      final originalHeight = originalImage.height;

      List<CroppedField> croppedFields = [];

      for (var detection in detections) {
        // Convert normalized coordinates (0-1) to pixel coordinates
        final x1 = ((detection.x - detection.width / 2) * originalWidth)
            .toInt()
            .clamp(0, originalWidth);
        final y1 = ((detection.y - detection.height / 2) * originalHeight)
            .toInt()
            .clamp(0, originalHeight);
        final x2 = ((detection.x + detection.width / 2) * originalWidth)
            .toInt()
            .clamp(0, originalWidth);
        final y2 = ((detection.y + detection.height / 2) * originalHeight)
            .toInt()
            .clamp(0, originalHeight);

        final cropWidth = x2 - x1;
        final cropHeight = y2 - y1;

        if (cropWidth <= 0 || cropHeight <= 0) continue;

        final croppedImage = img.copyCrop(
          originalImage,
          x: x1,
          y: y1,
          width: cropWidth,
          height: cropHeight,
        );

        final croppedPath = await _saveCroppedImage(
          croppedImage,
          detection.className,
        );

        croppedFields.add(
          CroppedField(
            fieldName: detection.className,
            confidence: detection.confidence,
            imagePath: croppedPath,
            bbox: BoundingBox(x1: x1, y1: y1, x2: x2, y2: y2),
          ),
        );
      }

      return croppedFields;
    } catch (e) {
      return [];
    }
  }

  static Future<String> _saveCroppedImage(
    img.Image image,
    String fieldName,
  ) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${fieldName}_$timestamp.jpg';
    final filePath = path.join(directory.path, fileName);

    final imageBytes = img.encodeJpg(image);
    await File(filePath).writeAsBytes(imageBytes);

    return filePath;
  }
}
