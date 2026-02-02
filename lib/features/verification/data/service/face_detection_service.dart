import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'package:mobile_app/features/verification/data/exceptions/no_face_detected_exception.dart';
import 'package:mobile_app/features/verification/domain/entities/bouding_box.dart';
import 'package:mobile_app/features/verification/domain/entities/face_detection_result.dart';
import 'package:mobile_app/features/verification/domain/entities/face_landmark.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceDetectionService {
  static const int inputWidth = 256;
  static const int inputHeight = 256;

  static Future<FaceDetectionResult> detectFace({
    required String imagePath,
    required int interpreterAddress,
    bool isIdCardImage = false,
  }) async {
    try {
      final result = await Isolate.run(
        () => _faceDetectionIsolate(
          imagePath: imagePath,
          interpreterAddress: interpreterAddress,
          isIdCardImage: isIdCardImage,
        ),
      );

      return result;
    } catch (e) {
      if (e is NoFaceDetectedException || e is MultipleFacesDetectedException) {
        rethrow;
      }
      rethrow;
    }
  }

  static Future<FaceDetectionResult> _faceDetectionIsolate({
    required String imagePath,
    required int interpreterAddress,
    required bool isIdCardImage,
  }) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final originalWidth = image.width;
      final originalHeight = image.height;

      final input = _preprocessImage(image);

      final interpreter = Interpreter.fromAddress(interpreterAddress);

      final outputBoxes = List.filled(1 * 896 * 16, 0.0).reshape([1, 896, 16]);
      final outputScores = List.filled(1 * 896 * 1, 0.0).reshape([1, 896, 1]);

      interpreter.runForMultipleInputs(
        [input],
        {0: outputBoxes, 1: outputScores},
      );

      final result = _postprocessOutputs(
        {'boxes': outputBoxes[0], 'scores': outputScores[0]},
        originalWidth,
        originalHeight,
        isIdCardImage: isIdCardImage,
      );

      if (result == null) {
        throw NoFaceDetectedException(
          'No face detected. Please ensure your face is clearly visible.',
        );
      }

      return result;
    } catch (e) {
      if (e is NoFaceDetectedException || e is MultipleFacesDetectedException) {
        throw Exception(e.toString());
      }

      throw Exception('Face detection failed: $e');
    }
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
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    return input;
  }

  static FaceDetectionResult? _postprocessOutputs(
    Map<String, dynamic> outputs,
    int originalWidth,
    int originalHeight, {
    required bool isIdCardImage,
  }) {
    final boxes = outputs['boxes'] as List;
    final scores = outputs['scores'] as List;

    final double actualConfidenceThreshold;
    final double minSizeRatio;

    if (isIdCardImage) {
      actualConfidenceThreshold = 0.5;
      minSizeRatio = 0.0;
    } else {
      actualConfidenceThreshold = 0.65;
      minSizeRatio = 0.20;
    }

    List<_Detection> allDetections = [];

    for (int i = 0; i < scores.length; i++) {
      final score = scores[i];
      final confidence = score is List ? _sigmoid(score[0]) : _sigmoid(score);

      if (confidence < actualConfidenceThreshold) continue;

      final box = boxes[i] as List<dynamic>;

      final cx = (box[0] as num).toDouble();
      final cy = (box[1] as num).toDouble();
      final w = (box[2] as num).toDouble();
      final h = (box[3] as num).toDouble();

      final faceWidth = w * originalWidth;
      final faceHeight = h * originalHeight;

      // Size-based filtering
      if (minSizeRatio > 0) {
        final minDimension = originalWidth < originalHeight
            ? originalWidth
            : originalHeight;
        final minSize = minDimension * minSizeRatio;

        if (faceWidth < minSize || faceHeight < minSize) {
          continue;
        }
      }

      final landmarks = <double>[];
      for (int j = 4; j < 16; j++) {
        landmarks.add((box[j] as num).toDouble());
      }

      allDetections.add(
        _Detection(
          confidence: confidence,
          box: [cx, cy, w, h],
          landmarks: landmarks,
        ),
      );
    }

    if (allDetections.isEmpty) {
      throw NoFaceDetectedException(
        'No face detected. Please ensure your face is clearly visible.',
      );
    }

    if (allDetections.length > 1) {
      allDetections = _applyNMS(allDetections, iouThreshold: 0.5);
    }

    allDetections.sort((a, b) {
      final scoreA = a.confidence * (a.box[2] * a.box[3]);
      final scoreB = b.confidence * (b.box[2] * b.box[3]);
      return scoreB.compareTo(scoreA);
    });

    if (!isIdCardImage && allDetections.length > 1) {
      throw MultipleFacesDetectedException(
        'Multiple faces detected. Please ensure only your face is visible.',
      );
    } 

    final best = allDetections.first;

    final scaleX = originalWidth / inputWidth;
    final scaleY = originalHeight / inputHeight;

    final x1 = (best.box[0] - best.box[2] / 2) * scaleX;
    final y1 = (best.box[1] - best.box[3] / 2) * scaleY;
    final boxWidth = best.box[2] * scaleX;
    final boxHeight = best.box[3] * scaleY;

    final rightEyeX = best.landmarks[0] * scaleX;
    final rightEyeY = best.landmarks[1] * scaleY;
    final leftEyeX = best.landmarks[2] * scaleX;
    final leftEyeY = best.landmarks[3] * scaleY;
    final noseX = best.landmarks[4] * scaleX;
    final noseY = best.landmarks[5] * scaleY;
    final mouthX = best.landmarks[6] * scaleX;
    final mouthY = best.landmarks[7] * scaleY;
    final rightEarX = best.landmarks[8] * scaleX;
    final rightEarY = best.landmarks[9] * scaleY;

    return FaceDetectionResult(
      boundingBox: BoundingBox(
        x: x1,
        y: y1,
        width: boxWidth,
        height: boxHeight,
      ),
      landmarks: FaceLandmarks(
        leftEye: Point(leftEyeX, leftEyeY),
        rightEye: Point(rightEyeX, rightEyeY),
        nose: Point(noseX, noseY),
        leftMouth: Point(mouthX, mouthY),
        rightMouth: Point(rightEarX, rightEarY),
      ),
      confidence: best.confidence,
    );
  }

  static double _sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
  }

  static double exp(double x) {
    return x.abs() > 20 ? (x > 0 ? 1e9 : 1e-9) : _expApprox(x);
  }

  static double _expApprox(double x) {
    const int iterations = 20;
    double result = 1.0;
    double term = 1.0;

    for (int i = 1; i <= iterations; i++) {
      term *= x / i;
      result += term;
    }

    return result;
  }

  /// Apply Non-Maximum Suppression to remove overlapping detections
  static List<_Detection> _applyNMS(
    List<_Detection> detections, {
    required double iouThreshold,
  }) {
    // Sort by confidence (highest first)
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    final List<_Detection> selected = [];
    final List<bool> suppressed = List.filled(detections.length, false);

    for (int i = 0; i < detections.length; i++) {
      if (suppressed[i]) continue;

      selected.add(detections[i]);

      // Suppress all detections that overlap significantly with this one
      for (int j = i + 1; j < detections.length; j++) {
        if (suppressed[j]) continue;

        final iou = _calculateIoU(detections[i], detections[j]);

        if (iou > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }

    return selected;
  }

  static double _calculateIoU(_Detection det1, _Detection det2) {
    final x1_1 = det1.box[0] - det1.box[2] / 2;
    final y1_1 = det1.box[1] - det1.box[3] / 2;
    final x2_1 = det1.box[0] + det1.box[2] / 2;
    final y2_1 = det1.box[1] + det1.box[3] / 2;

    final x1_2 = det2.box[0] - det2.box[2] / 2;
    final y1_2 = det2.box[1] - det2.box[3] / 2;
    final x2_2 = det2.box[0] + det2.box[2] / 2;
    final y2_2 = det2.box[1] + det2.box[3] / 2;

    final xLeft = x1_1 > x1_2 ? x1_1 : x1_2;
    final yTop = y1_1 > y1_2 ? y1_1 : y1_2;
    final xRight = x2_1 < x2_2 ? x2_1 : x2_2;
    final yBottom = y2_1 < y2_2 ? y2_1 : y2_2;

    if (xRight < xLeft || yBottom < yTop) {
      return 0.0; 
    }

    final intersectionArea = (xRight - xLeft) * (yBottom - yTop);

    final area1 = det1.box[2] * det1.box[3];
    final area2 = det2.box[2] * det2.box[3];
    final unionArea = area1 + area2 - intersectionArea;

    return intersectionArea / unionArea;
  }
}

class _Detection {
  final double confidence;
  final List<double> box;
  final List<double> landmarks;

  _Detection({
    required this.confidence,
    required this.box,
    required this.landmarks,
  });
}
