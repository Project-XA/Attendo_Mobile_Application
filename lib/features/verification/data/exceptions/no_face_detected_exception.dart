class NoFaceDetectedException implements Exception {
  final String message;
  NoFaceDetectedException(this.message);

  @override
  String toString() => message;
}

class MultipleFacesDetectedException implements Exception {
  final String message;
  MultipleFacesDetectedException(this.message);

  @override
  String toString() => message;
}

class LowConfidenceException implements Exception {
  final String message;
  LowConfidenceException(this.message);

  @override
  String toString() => message;
}

class FaceDetectionException implements Exception {
  final String message;
  FaceDetectionException(this.message);

  @override
  String toString() => message;
}