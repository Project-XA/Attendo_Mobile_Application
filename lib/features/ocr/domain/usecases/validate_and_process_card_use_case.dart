import 'package:mobile_app/features/ocr/domain/errors/ocr_error.dart';
import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_required_field_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/processing_result_use_case.dart';

class ValidateAndProcessCardUseCase {
  final CameraRepository _repository;
  final ValidateCardUseCase _validateCardUseCase;
  final ValidateRequiredFieldsUseCase _validateFieldsUseCase;
  final ProcessCardUseCase _processCardUseCase;

  ValidateAndProcessCardUseCase(
    this._repository,
    this._validateCardUseCase,
    this._validateFieldsUseCase,
    this._processCardUseCase,
  );

  Future<ValidateAndProcessCardResult> execute(CapturedPhoto photo) async {
    try {
      final isCard = await _validateCardUseCase.execute(photo);

      if (!isCard) {
        return const ValidateAndProcessCardResult(
          status: ValidateAndProcessCardStatus.invalidCard,
          error: OcrError(
            type: OcrErrorType.noCardDetected,
            message: 'No valid ID card detected in image.',
          ),
        );
      }

      final detections = await _repository.detectFields(photo);
      final validationResult = await _validateFieldsUseCase.execute(detections);

      if (!validationResult.isValid) {
        return const ValidateAndProcessCardResult(
          status: ValidateAndProcessCardStatus.missingRequiredFields,
          error: OcrError(
            type: OcrErrorType.missingRequiredFields,
            message: 'Required fields were not detected on the card.',
          ),
        );
      }

      final processingResult = await _processCardUseCase.execute(photo);
      final hasFirstName = processingResult.extractedData.firstName.isNotEmpty;
      final hasLastName = processingResult.extractedData.lastName.isNotEmpty;

      if (!hasFirstName || !hasLastName) {
        return ValidateAndProcessCardResult(
          status: ValidateAndProcessCardStatus.nameIncomplete,
          processingResult: processingResult,
          error: const OcrError(
            type: OcrErrorType.ocrFailure,
            message: 'Name fields could not be extracted from the card.',
          ),
        );
      }

      return ValidateAndProcessCardResult(
        status: ValidateAndProcessCardStatus.success,
        processingResult: processingResult,
      );
    } catch (e) {
      return ValidateAndProcessCardResult(
        status: ValidateAndProcessCardStatus.error,
        error: OcrError(
          type: OcrErrorType.unexpected,
          message: 'Unexpected OCR error',
          cause: e,
        ),
      );
    }
  }
}

enum ValidateAndProcessCardStatus {
  success,
  invalidCard,
  missingRequiredFields,
  nameIncomplete,
  error,
}

class ValidateAndProcessCardResult {
  final ValidateAndProcessCardStatus status;
  final CardProcessingResult? processingResult;
  final OcrError? error;

  const ValidateAndProcessCardResult({
    required this.status,
    this.processingResult,
    this.error,
  });
}
