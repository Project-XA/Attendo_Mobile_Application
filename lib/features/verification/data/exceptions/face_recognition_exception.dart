class FaceRecognitionException implements Exception {
  final String message;
  FaceRecognitionException(this.message);
  
  @override
  String toString() => message;
}

class FaceNotMatchedException implements Exception {
  final String message;
  final double similarity;
  
  FaceNotMatchedException(this.message, this.similarity);
  
  @override
  String toString() => message;
}