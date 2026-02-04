// face_recognition_service.dart
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:mobile_app/features/verification/data/exceptions/face_recognition_exception.dart';
import 'package:mobile_app/features/verification/domain/entities/face_detection_result.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  static const int inputWidth = 112;
  static const int inputHeight = 112;
  static const int embeddingSize = 192;
  static const double matchThreshold = 0.55;
  static const double minFaceConfidence = 0.6;
  static const double minFaceAreaRatio = 0.02;

  static Future<List<double>> extractEmbedding({
    required String imagePath,
    required int interpreterAddress,
    required FaceDetectionResult faceDetection,
  }) async {
    try {
      final result = await Isolate.run(
        () => _extractEmbeddingIsolate(
          imagePath: imagePath,
          interpreterAddress: interpreterAddress,
          faceDetection: faceDetection,
        ),
      );

      return result;
    } catch (e) {
      throw FaceRecognitionException('Failed to extract face embedding: $e');
    }
  }

  static Future<double> compareFaces({
    required String image1Path,
    required String image2Path,
    required int interpreterAddress,
    required FaceDetectionResult face1Detection,
    required FaceDetectionResult face2Detection,
  }) async {
    try {
      final embedding1 = await extractEmbedding(
        imagePath: image1Path,
        interpreterAddress: interpreterAddress,
        faceDetection: face1Detection,
      );

      final embedding2 = await extractEmbedding(
        imagePath: image2Path,
        interpreterAddress: interpreterAddress,
        faceDetection: face2Detection,
      );

      final similarity = _cosineSimilarity(embedding1, embedding2);

      return similarity;
    } catch (e) {
      throw FaceRecognitionException('Failed to compare faces: $e');
    }
  }

  static Future<bool> verifyFaces({
    required String image1Path,
    required String image2Path,
    required int interpreterAddress,
    required FaceDetectionResult face1Detection,
    required FaceDetectionResult face2Detection,
    double? customThreshold,
  }) async {
    try {
      final similarity = await compareFaces(
        image1Path: image1Path,
        image2Path: image2Path,
        interpreterAddress: interpreterAddress,
        face1Detection: face1Detection,
        face2Detection: face2Detection,
      );

      final threshold = customThreshold ?? matchThreshold;

      if (similarity < threshold) {
        throw FaceNotMatchedException(
          'الوجهان غير متطابقين. نسبة التطابق: ${(similarity * 100).toStringAsFixed(1)}%',
          similarity,
        );
      }
      return true;
    } on FaceNotMatchedException {
      rethrow;
    } catch (e) {
      throw FaceRecognitionException('Verification failed: $e');
    }
  }

  static Future<List<double>> _extractEmbeddingIsolate({
    required String imagePath,
    required int interpreterAddress,
    required FaceDetectionResult faceDetection,
  }) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      var image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      image = _alignFaceIfNeeded(image, faceDetection);

      final faceImage = _cropFaceImproved(image, faceDetection);

      final enhancedImage = _enhanceImageLight(faceImage);

      final input = _preprocessImage(enhancedImage);

      final interpreter = Interpreter.fromAddress(interpreterAddress);

      final output = List.filled(
        1 * embeddingSize,
        0.0,
      ).reshape([1, embeddingSize]);

      interpreter.run(input, output);

      final embedding = _normalizeEmbedding(output[0]);

      double norm = 0.0;
      for (final value in embedding) {
        norm += value * value;
      }
      norm = math.sqrt(norm);

      return embedding;
    } catch (e) {
      throw Exception('Failed to extract embedding: $e');
    }
  }

  static img.Image _alignFaceIfNeeded(
    img.Image image,
    FaceDetectionResult faceDetection,
  ) {
    final landmarks = faceDetection.landmarks;

    final leftEye = landmarks.leftEye;
    final rightEye = landmarks.rightEye;

    final dY = rightEye.y - leftEye.y;
    final dX = rightEye.x - leftEye.x;
    final angle = math.atan2(dY, dX) * 180 / math.pi;

    if (angle.abs() > 10) {
      image = img.copyRotate(image, angle: -angle);
    }
    return image;
  }

  static img.Image _cropFaceImproved(
    img.Image image,
    FaceDetectionResult faceDetection,
  ) {
    final box = faceDetection.boundingBox;

    const padding = 0.25;

    final expandedWidth = box.width * (1 + padding);
    final expandedHeight = box.height * (1 + padding);

    final size = math.max(expandedWidth, expandedHeight);

    final centerX = box.centerX;
    final centerY = box.centerY;

    var x = (centerX - size / 2).round();
    var y = (centerY - size / 2).round();
    var width = size.round();
    var height = size.round();
    x = math.max(0, x);
    y = math.max(0, y);
    width = math.min(width, image.width - x);
    height = math.min(height, image.height - y);

    return img.copyCrop(image, x: x, y: y, width: width, height: height);
  }

  static img.Image _enhanceImageLight(img.Image image) {
    image = img.contrast(image, contrast: 102);

    return image;
  }

  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final resized = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.linear,
    );

    final input = List.generate(
      1,
      (_) => List.generate(
        inputHeight,
        (y) => List.generate(inputWidth, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.r - 127.5) / 128.0,
            (pixel.g - 127.5) / 128.0,
            (pixel.b - 127.5) / 128.0,
          ];
        }),
      ),
    );

    return input;
  }

  static List<double> _normalizeEmbedding(List<dynamic> embedding) {
    final embedList = embedding.map((e) => (e as num).toDouble()).toList();

    double norm = 0.0;
    for (final value in embedList) {
      norm += value * value;
    }
    norm = math.sqrt(norm);

    if (norm > 0) {
      final normalized = embedList.map((value) => value / norm).toList();

      return normalized;
    }
    return embedList;
  }

  static double _cosineSimilarity(
    List<double> embedding1,
    List<double> embedding2,
  ) {
    if (embedding1.length != embedding2.length) {
      throw Exception('Embeddings must have the same length');
    }

    double dotProduct = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
    }

    double norm1 = 0.0;
    double norm2 = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }
    norm1 = math.sqrt(norm1);
    norm2 = math.sqrt(norm2);

    return dotProduct;
  }
}
