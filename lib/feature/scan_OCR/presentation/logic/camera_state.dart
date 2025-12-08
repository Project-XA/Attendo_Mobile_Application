import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraState {
  final CameraController? controller;
  final bool isOpened;
  final bool hasCaptured;
  final CapturedPhoto? photo;
  final bool isInitializing;
  final bool isProcessing;
  final bool showResult;
  final bool hasError; 
  final List<CroppedField>? croppedFields;
  final Map<String, String>? extractedText;
  final Map<String, String>? finalData;

  CameraState({
    this.controller,
    this.isOpened = false,
    this.hasCaptured = false,
    this.photo,
    this.isInitializing = false,
    this.isProcessing = false,
    this.showResult = false,
    this.hasError = false, 
    this.croppedFields,
    this.extractedText,
    this.finalData,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isOpened,
    bool? hasCaptured,
    CapturedPhoto? photo,
    bool? isInitializing,
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
      hasCaptured: hasCaptured ?? this.hasCaptured,
      photo: photo ?? this.photo,
      isInitializing: isInitializing ?? this.isInitializing,
      isProcessing: isProcessing ?? this.isProcessing,
      showResult: showResult ?? this.showResult,
      hasError: hasError ?? this.hasError, 
      croppedFields: croppedFields ?? this.croppedFields,
      extractedText: extractedText ?? this.extractedText,
      finalData: finalData ?? this.finalData,
    );
  }
}