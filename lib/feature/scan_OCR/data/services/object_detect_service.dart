import 'dart:isolate';
import 'dart:typed_data';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_processing_service.dart';

class ObjectDetectionService {
  static Future<List<DetectionModel>> detectFields({
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

    final result = await receivePort.first as List<DetectionModel>;
    return result;
  }

  static void _objectDetectionIsolate(_ObjectDetectionData data) async {
    try {
      print("🔍 [Object Detection] Starting field detection...");

      final inputBytes = ImageProcessingService.preprocessImage(
        data.imagePath,
        targetWidth: 640,
        targetHeight: 640,
      );

      final interpreter = Interpreter.fromAddress(data.interpreterAddress);
      final output = _runInference(interpreter, inputBytes);

      final detections = _processDetections(
        output,
        confidenceThreshold: data.confidenceThreshold,
      );

      // Print results
      _logDetections(detections);

      data.sendPort.send(detections);
    } catch (e) {
      print("❌ [Object Detection] Error: $e");
      data.sendPort.send(<DetectionModel>[]);
    }
  }

  static List _runInference(Interpreter interpreter, Float32List inputBytes) {
    print("🚀 [Object Detection] Running inference...");

    final input = inputBytes.reshape([1, 640, 640, 3]);
    final outputBytes = Float32List(1 * 35 * 8400);
    final output = outputBytes.reshape([1, 35, 8400]);

    interpreter.run(input, output);
    print("✅ [Object Detection] Inference complete");

    return output;
  }

  static List<DetectionModel> _processDetections(
    List output, {
    required double confidenceThreshold,
  }) {
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

    List<DetectionModel> detections = [];

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
        detections.add(DetectionModel(
          classId: bestClass,
          className: bestClass < labels.length ? labels[bestClass] : 'unknown',
          confidence: maxConfidence,
          x: x,
          y: y,
          width: w,
          height: h,
        ));
      }
    }

    // Apply NMS
    detections = _applyNMS(detections, iouThreshold: 0.5);
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    return detections;
  }

  static void _logDetections(List<DetectionModel> detections) {
    print("📊 [Object Detection] Processing detections...");
    print("=" * 60);

    final validDetections = detections.where((d) => !d.className.startsWith('invalid_')).toList();
    final invalidDetections = detections.where((d) => d.className.startsWith('invalid_')).toList();

    print("✅ Valid Fields: ${validDetections.length}");
    print("❌ Invalid Fields: ${invalidDetections.length}");
    print("");

    if (validDetections.isNotEmpty) {
      print("📗 VALID FIELDS:");
      for (var detection in validDetections) {
        _printDetection(detection);
      }
    }

    if (invalidDetections.isNotEmpty) {
      print("📕 INVALID FIELDS:");
      for (var detection in invalidDetections) {
        _printDetection(detection);
      }
    }

    if (detections.isEmpty) {
      print("⚠️ No fields detected!");
    }

    print("=" * 60);
  }

  static void _printDetection(DetectionModel detection) {
    final x1 = ((detection.x - detection.width / 2) * 640).toInt();
    final y1 = ((detection.y - detection.height / 2) * 640).toInt();
    final x2 = ((detection.x + detection.width / 2) * 640).toInt();
    final y2 = ((detection.y + detection.height / 2) * 640).toInt();

    print("📍 ${detection.className.toUpperCase()}");
    print("   Confidence: ${(detection.confidence * 100).toStringAsFixed(2)}%");
    print("   Bounding Box: [x1: $x1, y1: $y1, x2: $x2, y2: $y2]");
    print("");
  }

  static List<DetectionModel> _applyNMS(List<DetectionModel> detections, {double iouThreshold = 0.5}) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    List<DetectionModel> result = [];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      result.add(best);

      detections.removeWhere((detection) {
        if (detection.classId != best.classId) return false;
        return _calculateIOU(best, detection) > iouThreshold;
      });
    }

    return result;
  }

  static double _calculateIOU(DetectionModel a, DetectionModel b) {
    final x1A = a.x - a.width / 2;
    final y1A = a.y - a.height / 2;
    final x2A = a.x + a.width / 2;
    final y2A = a.y + a.height / 2;

    final x1B = b.x - b.width / 2;
    final y1B = b.y - b.height / 2;
    final x2B = b.x + b.width / 2;
    final y2B = b.y + b.height / 2;

    final x1Inter = x1A > x1B ? x1A : x1B;
    final y1Inter = y1A > y1B ? y1A : y1B;
    final x2Inter = x2A < x2B ? x2A : x2B;
    final y2Inter = y2A < y2B ? y2A : y2B;

    if (x2Inter <= x1Inter || y2Inter <= y1Inter) {
      return 0.0;
    }

    final interArea = (x2Inter - x1Inter) * (y2Inter - y1Inter);
    final areaA = a.width * a.height;
    final areaB = b.width * b.height;

    return interArea / (areaA + areaB - interArea);
  }
}

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
            int index = b * (shape[1] * shape[2] * shape[3]) +
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