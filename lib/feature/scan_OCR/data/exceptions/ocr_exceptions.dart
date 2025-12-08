abstract class OcrException implements Exception {
  final String message;
  final dynamic originalError;

  const OcrException(this.message, [this.originalError]);

  @override
  String toString() => 'OcrException: $message${originalError != null ? ' - $originalError' : ''}';
}

class CameraNotInitializedException extends OcrException {
  const CameraNotInitializedException([String? message])
      : super(message ?? 'Camera not initialized. Call openCamera() first.');
}

class ModelLoadException extends OcrException {
  final String modelPath;

  const ModelLoadException(this.modelPath, [dynamic originalError])
      : super('Failed to load model: $modelPath', originalError);
}

class CardDetectionException extends OcrException {
  const CardDetectionException([String? message, dynamic originalError])
      : super(message ?? 'Failed to detect card', originalError);
}

class FieldDetectionException extends OcrException {
  const FieldDetectionException([String? message, dynamic originalError])
      : super(message ?? 'Failed to detect fields', originalError);
}

class ImageProcessingException extends OcrException {
  const ImageProcessingException([String? message, dynamic originalError])
      : super(message ?? 'Failed to process image', originalError);
}

class OcrExtractionException extends OcrException {
  final String imagePath;

  const OcrExtractionException(this.imagePath, [dynamic originalError])
      : super('Failed to extract text from image: $imagePath', originalError);
}

class DigitRecognitionException extends OcrException {
  const DigitRecognitionException([String? message, dynamic originalError])
      : super(message ?? 'Failed to recognize digits', originalError);
}

class CropServiceException extends OcrException {
  const CropServiceException([String? message, dynamic originalError])
      : super(message ?? 'Failed to crop image fields', originalError);
}

class ModelNotLoadedException extends OcrException {
  const ModelNotLoadedException([String? message])
      : super(message ?? 'Model not loaded. Call loadModel() first.');
}