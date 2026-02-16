import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_and_process_card_use_case.dart';
import 'package:mobile_app/features/ocr/presentation/logic/camera_state.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _repository;
  final CapturePhotoUseCase _captureUseCase;
  final ValidateAndProcessCardUseCase _pipelineUseCase;
  final SaveScannedCardUseCase _saveCardUseCase;

  CameraCubit(
    this._repository,
    this._captureUseCase,
    this._pipelineUseCase,
    this._saveCardUseCase,
  ) : super(const CameraState());

  CameraController? get controller => state.controller;
  bool get isInitialized => state.isOpened;
  bool get isBusy => state.isBusy;

  void _startProcessing() {
    emit(
      state.copyWith(
        isProcessing: true,
        hasError: false,
        showInvalidCardMessage: false,
      ),
    );
  }

  Future<void> _showTemporaryMessageAndReopen({
    required String message,
    bool isError = false,
  }) async {
    emit(
      state.copyWith(
        isProcessing: false,
        showResult: false,
        hasError: isError,
        hasCaptured: false,
        showInvalidCardMessage: true,
        errorMessage: message,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        showInvalidCardMessage: false,
        errorMessage: null,
        hasError: false,
      ),
    );

    await openCamera();
  }

  void _emitCapturedPhotoState(CapturedPhoto photo) {
    emit(
      state.copyWith(
        isOpened: false,
        controller: null,
        hasCaptured: true,
        photo: photo,
        isProcessing: true,
      ),
    );
  }

  Future<void> openCamera() async {
    if (state.isOpened) return;

    emit(
      state.copyWith(
        isInitializing: true,
        hasError: false,
        hasPermissionDenied: false,
        showInvalidCardMessage: false,
      ),
    );

    try {
      final status = await Permission.camera.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.camera.request();

        if (result.isDenied || result.isPermanentlyDenied) {
          emit(
            state.copyWith(
              isInitializing: false,
              isOpened: false,
              hasError: false,
              hasPermissionDenied: true,
            ),
          );
          return;
        }
      }

      await _repository.openCamera();
      emit(
        state.copyWith(
          isOpened: true,
          isInitializing: false,
          controller: _repository.controller,
          hasError: false,
          hasPermissionDenied: false,
          showInvalidCardMessage: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isInitializing: false,
          isOpened: false,
          hasError: true,
          hasPermissionDenied: false,
        ),
      );
      rethrow;
    }
  }

  Future<void> closeCamera() async {
    if (!state.isOpened) return;
    await _repository.closeCamera();
    emit(state.copyWith(isOpened: false, controller: null));
  }

  Future<void> capturePhoto() async {
    if (!state.canCapture) return;

    _startProcessing();

    try {
      final photo = await _captureUseCase.execute();
      await _repository.closeCamera();

      _emitCapturedPhotoState(photo);

      final pipelineResult = await _pipelineUseCase.execute(photo);

      switch (pipelineResult.status) {
        case ValidateAndProcessCardStatus.invalidCard:
          await _showTemporaryMessageAndReopen(
            message: 'Please use a valid ID card',
          );
          return;
        case ValidateAndProcessCardStatus.missingRequiredFields:
          await _showTemporaryMessageAndReopen(
            message: 'Required fields missing. Please try again',
          );
          return;
        case ValidateAndProcessCardStatus.nameIncomplete:
          await _showTemporaryMessageAndReopen(
            message: 'Could not extract name. Please try again',
          );
          return;
        case ValidateAndProcessCardStatus.error:
          await _showTemporaryMessageAndReopen(
            message: 'An error occurred. Please try again',
            isError: true,
          );
          return;
        case ValidateAndProcessCardStatus.success:
          final result = pipelineResult.processingResult!;
          emit(
            state.copyWith(
              isProcessing: false,
              showResult: true,
              croppedFields: result.croppedFields,
              finalData: result.rawData,
              extractedData: result.extractedData,
              hasError: false,
            ),
          );
          return;
      }
    } catch (e) {
      await _showTemporaryMessageAndReopen(
        message: 'An error occurred. Please try again',
        isError: true,
      );
    }
  }

  Future<void> verifyAndSaveData() async {
    if (state.extractedData == null) return;
    try {
      await _saveCardUseCase.execute(state.extractedData!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> retakePhoto() async {
    if (!state.canRetake) return;

    emit(
      state.copyWith(
        photo: null,
        hasCaptured: false,
        showResult: false,
        croppedFields: null,
        extractedText: null,
        finalData: null,
        hasError: false,
        showInvalidCardMessage: false,
      ),
    );

    await openCamera();
  }

  void clearResults() {
    emit(const CameraState());
  }

  @override
  Future<void> close() async {
    await _repository.closeCamera();
    return super.close();
  }
}
