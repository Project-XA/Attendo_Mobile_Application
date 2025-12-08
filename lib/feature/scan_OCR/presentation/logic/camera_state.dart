// ============================================================================
// CAMERA STATE - COMPLETE IMPROVED VERSION
// ============================================================================

import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraState {
  // ========== Camera Properties ==========
  
  /// Camera controller instance
  final CameraController? controller;
  
  /// Whether the camera is opened and ready
  final bool isOpened;
  
  /// Whether the camera is currently initializing
  final bool isInitializing;

  // ========== Capture Properties ==========
  
  /// Whether a photo has been captured
  final bool hasCaptured;
  
  /// The captured photo
  final CapturedPhoto? photo;
  
  /// Whether the captured photo is being processed
  final bool isProcessing;

  // ========== Result Properties ==========
  
  /// Whether to show results screen
  final bool showResult;
  
  /// List of cropped field images
  final List<CroppedField>? croppedFields;
  
  /// Extracted text from fields (raw OCR results)
  final Map<String, String>? extractedText;
  
  /// Final processed data ready for display
  final Map<String, String>? finalData;

  // ========== Error Handling ==========
  
  /// Whether an error occurred during any operation
  final bool hasError;

  // ========== Constructor ==========
  
  const CameraState({
    this.controller,
    this.isOpened = false,
    this.isInitializing = false,
    this.hasCaptured = false,
    this.photo,
    this.isProcessing = false,
    this.showResult = false,
    this.croppedFields,
    this.extractedText,
    this.finalData,
    this.hasError = false,
  });

  // ========== Computed Properties ==========
  
  /// Whether any async operation is in progress
  bool get isBusy => isInitializing || isProcessing;

  /// Whether the camera is ready to capture
  bool get canCapture => isOpened && !isBusy && !hasCaptured;

  /// Whether user can retake a photo
  bool get canRetake => hasCaptured && !isBusy;

  /// Whether we have processed results to display
  bool get hasResults => showResult && finalData != null && finalData!.isNotEmpty;

  /// Whether the captured image was a valid card
  bool get isValidCard => hasCaptured && (showResult || isProcessing);

  /// Whether the captured image was invalid
  bool get isInvalidCard => hasCaptured && !showResult && !isProcessing;

  /// Camera initialization status
  CameraStatus get cameraStatus {
    if (isInitializing) return CameraStatus.initializing;
    if (isOpened) return CameraStatus.ready;
    if (hasError) return CameraStatus.error;
    return CameraStatus.closed;
  }

  /// Processing status
  ProcessingStatus get processingStatus {
    if (isProcessing) return ProcessingStatus.processing;
    if (hasResults) return ProcessingStatus.completed;
    if (isInvalidCard) return ProcessingStatus.invalidCard;
    if (hasError) return ProcessingStatus.error;
    return ProcessingStatus.idle;
  }

  // ========== Helper Methods ==========

  /// Get specific field value from final data
  String getFieldValue(String fieldName, {String defaultValue = 'N/A'}) {
    return finalData?[fieldName] ?? defaultValue;
  }

  /// Check if a specific field exists and has value
  bool hasFieldValue(String fieldName) {
    final value = finalData?[fieldName];
    return value != null && value.isNotEmpty;
  }

  /// Get all valid (non-empty) fields
  Map<String, String> get validFields {
    if (finalData == null) return {};
    return Map.fromEntries(
      finalData!.entries.where((entry) => entry.value.isNotEmpty),
    );
  }

  /// Count of successfully extracted fields
  int get extractedFieldsCount => validFields.length;

  // ========== Copy With Method ==========
  
  CameraState copyWith({
    CameraController? controller,
    bool? isOpened,
    bool? isInitializing,
    bool? hasCaptured,
    CapturedPhoto? photo,
    bool? isProcessing,
    bool? showResult,
    bool? hasError,
    List<CroppedField>? croppedFields,
    Map<String, String>? extractedText,
    Map<String, String>? finalData,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isOpened: isOpened ?? this.isOpened,
      isInitializing: isInitializing ?? this.isInitializing,
      hasCaptured: hasCaptured ?? this.hasCaptured,
      photo: photo ?? this.photo,
      isProcessing: isProcessing ?? this.isProcessing,
      showResult: showResult ?? this.showResult,
      hasError: hasError ?? this.hasError,
      croppedFields: croppedFields ?? this.croppedFields,
      extractedText: extractedText ?? this.extractedText,
      finalData: finalData ?? this.finalData,
    );
  }

  // ========== Equality & HashCode ==========
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CameraState &&
        other.controller == controller &&
        other.isOpened == isOpened &&
        other.isInitializing == isInitializing &&
        other.hasCaptured == hasCaptured &&
        other.photo == photo &&
        other.isProcessing == isProcessing &&
        other.showResult == showResult &&
        other.hasError == hasError;
  }

  @override
  int get hashCode {
    return controller.hashCode ^
        isOpened.hashCode ^
        isInitializing.hashCode ^
        hasCaptured.hashCode ^
        photo.hashCode ^
        isProcessing.hashCode ^
        showResult.hashCode ^
        hasError.hashCode;
  }

  // ========== String Representation ==========
  
  @override
  String toString() {
    return 'CameraState('
        'isOpened: $isOpened, '
        'isInitializing: $isInitializing, '
        'hasCaptured: $hasCaptured, '
        'isProcessing: $isProcessing, '
        'showResult: $showResult, '
        'hasError: $hasError, '
        'extractedFields: $extractedFieldsCount'
        ')';
  }
}

// ========== Enums for Status ==========

/// Camera initialization and connection status
enum CameraStatus {
  /// Camera is closed
  closed,
  
  /// Camera is being initialized
  initializing,
  
  /// Camera is ready to capture
  ready,
  
  /// Camera encountered an error
  error,
}

/// Photo processing status
enum ProcessingStatus {
  /// No processing happening
  idle,
  
  /// Currently processing the photo
  processing,
  
  /// Processing completed successfully
  completed,
  
  /// Captured image is not a valid card
  invalidCard,
  
  /// Error occurred during processing
  error,
}

// ========== Extension for Status Display ==========

extension CameraStatusExtension on CameraStatus {
  String get displayText {
    switch (this) {
      case CameraStatus.closed:
        return 'Camera Closed';
      case CameraStatus.initializing:
        return 'Initializing Camera...';
      case CameraStatus.ready:
        return 'Ready to Capture';
      case CameraStatus.error:
        return 'Camera Error';
    }
  }

  bool get isReady => this == CameraStatus.ready;
  bool get hasError => this == CameraStatus.error;
}

extension ProcessingStatusExtension on ProcessingStatus {
  String get displayText {
    switch (this) {
      case ProcessingStatus.idle:
        return 'Ready';
      case ProcessingStatus.processing:
        return 'Processing...';
      case ProcessingStatus.completed:
        return 'Completed';
      case ProcessingStatus.invalidCard:
        return 'Invalid Card';
      case ProcessingStatus.error:
        return 'Processing Error';
    }
  }

  bool get isProcessing => this == ProcessingStatus.processing;
  bool get isCompleted => this == ProcessingStatus.completed;
  bool get hasError => this == ProcessingStatus.error;
}