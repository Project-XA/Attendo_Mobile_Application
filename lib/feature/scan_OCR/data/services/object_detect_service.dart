import 'dart:isolate';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_processing_service.dart';

class ObjectDetectionService {
  static Future<void> detectFields({
    required String imagePath,
    required int interpreterAddress,
    double confidenceThreshold = 0.5,
  }) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _objectDetectionIsolate,
      _ObjectDetectionData(
        sendPort: receivePort.sendPort,
        imagePath: imagePath,
        interpreterAddress: interpreterAddress,
        confidenceThreshold: confidenceThreshold,
      ),
    );

    await receivePort.first;
  }

  static void _objectDetectionIsolate(_ObjectDetectionData data) async {
    try {
      print("🔍 [Object Detection] Starting field detection...");

      // Preprocess image
      final inputBytes = ImageProcessingService.preprocessImage(
        data.imagePath,
        targetWidth: 640,
        targetHeight: 640,
      );

      // Run inference
      final interpreter = Interpreter.fromAddress(data.interpreterAddress);
      final output = _runInference(interpreter, inputBytes);

      // Process results and print coordinates
      _processAndLogDetections(
        output,
        confidenceThreshold: data.confidenceThreshold,
      );

      data.sendPort.send(true);
    } catch (e) {
      print("❌ [Object Detection] Error: $e");
      data.sendPort.send(false);
    }
  }

  static List _runInference(Interpreter interpreter, Float32List inputBytes) {
    print("🚀 [Object Detection] Running inference...");

    final input = inputBytes.reshape([1, 640, 640, 3]);
    final outputBytes = Float32List(
      1 * 35 * 8400,
    ); // 37 = 4 (bbox) + 1 (conf) + 32 (classes)
    final output = outputBytes.reshape([1, 35, 8400]);

    interpreter.run(input, output);
    print("✅ [Object Detection] Inference complete");

    return output;
  }

  static void _processAndLogDetections(
    List output, {
    required double confidenceThreshold,
  }) {
    print("📊 [Object Detection] Processing detections...");
    print("=" * 60);

    final labels = [
      'address',
      'demo',
      'dob',
      'expiry',
      'firstName',
      'front_logo',
      'invalid_address',
      'invalid_barcode',
      'invalid_demo',
      'invalid_dob',
      'invalid_expiry',
      'invalid_firstName',
      'invalid_issue',
      'invalid_job',
      'invalid_lastName',
      'invalid_logo',
      'invalid_nid',
      'invalid_nid_back',
      'invalid_photo',
      'invalid_poe',
      'invalid_serial',
      'invalid_watermark_tut',
      'issue',
      'job',
      'lastName',
      'nid',
      'nid_back',
      'photo',
      'poe',
      'serial',
    ];

    List<Detection> detections = [];

    for (int i = 0; i < 8400; i++) {
      final x = output[0][0][i] as double;
      final y = output[0][1][i] as double;
      final w = output[0][2][i] as double;
      final h = output[0][3][i] as double;

      double maxConfidence = 0.0;
      int bestClass = -1;

      for (int classIdx = 0; classIdx < 30; classIdx++) {
        final confidence = output[0][4 + classIdx][i] as double;
        if (confidence > maxConfidence) {
          maxConfidence = confidence;
          bestClass = classIdx;
        }
      }

      if (maxConfidence > confidenceThreshold && bestClass != -1) {
        detections.add(
          Detection(
            classId: bestClass,
            className: bestClass < labels.length
                ? labels[bestClass]
                : 'unknown',
            confidence: maxConfidence,
            x: x,
            y: y,
            width: w,
            height: h,
          ),
        );
      }
    }

    detections = _applyNMS(detections, iouThreshold: 0.5);

    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    if (detections.isEmpty) {
      print("⚠️ No fields detected above threshold!");
    } else {
      print("✅ Found ${detections.length} fields:");
      print("");

      for (var detection in detections) {
        final x1 = ((detection.x - detection.width / 2) * 640).toInt();
        final y1 = ((detection.y - detection.height / 2) * 640).toInt();
        final x2 = ((detection.x + detection.width / 2) * 640).toInt();
        final y2 = ((detection.y + detection.height / 2) * 640).toInt();

        print("📍 ${detection.className.toUpperCase()}");
        print(
          "   Confidence: ${(detection.confidence * 100).toStringAsFixed(2)}%",
        );
        print("   Bounding Box: [x1: $x1, y1: $y1, x2: $x2, y2: $y2]");
        print(
          "   Center: (${(detection.x * 640).toInt()}, ${(detection.y * 640).toInt()})",
        );
        print(
          "   Size: ${(detection.width * 640).toInt()}x${(detection.height * 640).toInt()}",
        );
        print("");
      }
    }

    print("=" * 60);
  }

  static List<Detection> _applyNMS(
    List<Detection> detections, {
    double iouThreshold = 0.5,
  }) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    List<Detection> result = [];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      result.add(best);

      detections.removeWhere((detection) {
        // Only apply NMS for same class
        if (detection.classId != best.classId) return false;

        return _calculateIOU(best, detection) > iouThreshold;
      });
    }

    return result;
  }

  static double _calculateIOU(Detection a, Detection b) {
    final x1_a = a.x - a.width / 2;
    final y1_a = a.y - a.height / 2;
    final x2_a = a.x + a.width / 2;
    final y2_a = a.y + a.height / 2;

    final x1_b = b.x - b.width / 2;
    final y1_b = b.y - b.height / 2;
    final x2_b = b.x + b.width / 2;
    final y2_b = b.y + b.height / 2;

    final x1_inter = x1_a > x1_b ? x1_a : x1_b;
    final y1_inter = y1_a > y1_b ? y1_a : y1_b;
    final x2_inter = x2_a < x2_b ? x2_a : x2_b;
    final y2_inter = y2_a < y2_b ? y2_a : y2_b;

    if (x2_inter <= x1_inter || y2_inter <= y1_inter) {
      return 0.0;
    }

    final interArea = (x2_inter - x1_inter) * (y2_inter - y1_inter);
    final areaA = a.width * a.height;
    final areaB = b.width * b.height;

    return interArea / (areaA + areaB - interArea);
  }
}

// Data classes
class _ObjectDetectionData {
  final SendPort sendPort;
  final String imagePath;
  final int interpreterAddress;
  final double confidenceThreshold;

  _ObjectDetectionData({
    required this.sendPort,
    required this.imagePath,
    required this.interpreterAddress,
    required this.confidenceThreshold,
  });
}

class Detection {
  final int classId;
  final String className;
  final double confidence;
  final double x; // normalized center x
  final double y; // normalized center y
  final double width; // normalized width
  final double height; // normalized height

  Detection({
    required this.classId,
    required this.className,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

// Float32List reshape extension
extension Float32ListReshape on Float32List {
  List reshape(List<int> shape) {
    int totalElements = shape.reduce((a, b) => a * b);
    if (totalElements != length) {
      throw Exception('Cannot reshape: $totalElements != $length');
    }

    if (shape.length == 4) {
      return _reshape4D(shape);
    } else if (shape.length == 3) {
      return _reshape3D(shape);
    }

    throw Exception('Unsupported reshape: ${shape.length}D');
  }

  List _reshape4D(List<int> shape) {
    return List.generate(
      shape[0],
      (b) => List.generate(
        shape[1],
        (h) => List.generate(
          shape[2],
          (w) => List.generate(shape[3], (c) {
            int index =
                b * (shape[1] * shape[2] * shape[3]) +
                h * (shape[2] * shape[3]) +
                w * shape[3] +
                c;
            return this[index];
          }),
        ),
      ),
    );
  }

  List _reshape3D(List<int> shape) {
    return List.generate(
      shape[0],
      (b) => List.generate(
        shape[1],
        (c) => List.generate(shape[2], (d) {
          int index = b * (shape[1] * shape[2]) + c * shape[2] + d;
          return this[index];
        }),
      ),
    );
  }
}
