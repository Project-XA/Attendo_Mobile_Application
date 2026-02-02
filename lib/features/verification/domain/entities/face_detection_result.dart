
import 'package:mobile_app/features/verification/domain/entities/bouding_box.dart';
import 'package:mobile_app/features/verification/domain/entities/face_landmark.dart';

class FaceDetectionResult {
  final BoundingBox boundingBox;
  final FaceLandmarks landmarks;
  final double confidence;

  const FaceDetectionResult({
    required this.boundingBox,
    required this.landmarks,
    required this.confidence,
  });

  bool get isConfident => confidence > 0.5; 

  @override
  String toString() {
    return 'FaceDetectionResult(\n'
        '  box: $boundingBox,\n'
        '  confidence: ${(confidence * 100).toStringAsFixed(1)}%,\n'
        '  landmarks: $landmarks\n'
        ')';
  }
}