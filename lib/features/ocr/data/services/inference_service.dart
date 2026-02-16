import 'dart:isolate';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_processing_service.dart';

class InferenceService {
  static Future<CardDetectionResult> detectCard({
    required String imagePath,
    required int interpreterAddress,
    double confidenceThreshold = 0.3,
  }) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _cardDetectionIsolate,
        _IsolateData(
          sendPort: receivePort.sendPort,
          imagePath: imagePath,
          interpreterAddress: interpreterAddress,
          confidenceThreshold: confidenceThreshold,
        ),
      );

      final result = await receivePort.first as CardDetectionResult;
      return result;
    } finally {
      receivePort.close();
    }
  }

  static void _cardDetectionIsolate(_IsolateData data) async {
    try {
      final inputBytes = ImageProcessingService.preprocessImage(
        data.imagePath,
        targetWidth: 640,
        targetHeight: 640,
      );

      final interpreter = Interpreter.fromAddress(data.interpreterAddress);
      final output = _runInference(interpreter, inputBytes);

      final result = _processYoloOutput(
        output,
        confidenceThreshold: data.confidenceThreshold,
      );

      data.sendPort.send(result);
    } catch (e) {
      data.sendPort.send(
        CardDetectionResult(
          isCardDetected: false,
          confidence: 0.0,
          detectedClass: -1,
          label: null,
        ),
      );
    }
  }

  static List _runInference(Interpreter interpreter, Float32List inputBytes) {
    final input = inputBytes.reshape([1, 640, 640, 3]);
    final outputBytes = Float32List(1 * 12 * 8400);
    final output = outputBytes.reshape([1, 12, 8400]);

    interpreter.run(input, output);

    return output;
  }

  static CardDetectionResult _processYoloOutput(
    List output, {
    required double confidenceThreshold,
  }) {
    double maxConfidence = 0.0;
    int bestClass = -1;

    for (int i = 0; i < 8400; i++) {
      for (int classIdx = 0; classIdx < 8; classIdx++) {
        final confidence = output[0][4 + classIdx][i] as double;

        if (confidence > maxConfidence) {
          maxConfidence = confidence;
          bestClass = classIdx;
        }
      }
    }

    final labels = [
      'back-bottom',
      'back-left',
      'back-right',
      'back-up',
      'front-bottom',
      'front-left',
      'front-right',
      'front-up',
    ];

    final label = bestClass >= 0 && bestClass < labels.length
        ? labels[bestClass]
        : null;

    final isDetected = maxConfidence > confidenceThreshold && bestClass != -1;

    return CardDetectionResult(
      isCardDetected: isDetected,
      confidence: maxConfidence,
      detectedClass: bestClass,
      label: label,
    );
  }
}

class _IsolateData {
  final SendPort sendPort;
  final String imagePath;
  final int interpreterAddress;
  final double confidenceThreshold;

  _IsolateData({
    required this.sendPort,
    required this.imagePath,
    required this.interpreterAddress,
    required this.confidenceThreshold,
  });
}

class CardDetectionResult {
  final bool isCardDetected;
  final double confidence;
  final int detectedClass;
  final String? label;

  CardDetectionResult({
    required this.isCardDetected,
    required this.confidence,
    required this.detectedClass,
    required this.label,
  });
}
