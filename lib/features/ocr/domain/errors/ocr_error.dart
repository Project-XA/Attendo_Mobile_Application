enum OcrErrorType {
  permissionDenied,
  noCardDetected,
  missingRequiredFields,
  ocrFailure,
  unexpected,
}

class OcrError {
  final OcrErrorType type;
  final String message;
  final Object? cause;

  const OcrError({
    required this.type,
    required this.message,
    this.cause,
  });

  @override
  String toString() => 'OcrError(type: $type, message: $message, cause: $cause)';
}

