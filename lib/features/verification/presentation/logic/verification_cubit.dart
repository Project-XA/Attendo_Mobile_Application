import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/features/verification/data/exceptions/face_recognition_exception.dart';
import 'package:mobile_app/features/verification/data/exceptions/no_face_detected_exception.dart';
import 'package:mobile_app/features/verification/domain/repo/verify_repo.dart';
import 'package:mobile_app/features/verification/domain/use_case/face_verify_use_case.dart';
import 'package:mobile_app/features/verification/domain/use_case/load_id_card_for_verification.dart';
import 'package:mobile_app/features/verification/presentation/logic/verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit(
    this._faceVerifyUseCase,
    this._verifyRepo,
    this._loadIdCardForVerification,
  ) : super(const VerificationState());

  final FaceVerifyUseCase _faceVerifyUseCase;
  final VerifyRepo _verifyRepo;
  final LoadIdCardForVerification _loadIdCardForVerification;

  CameraController? get controller => state.controller;

  Future<void> opencamera() async {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        isInitializing: true,
        clearError: true,
        hasPermissionDenied: false,
        isnotVerified: false,
        hascaptured: false,
        isVerificationComplete: false,
        clearController: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      await _verifyRepo.openCamera();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          isOpened: true,
          isCameraInitialized: _verifyRepo.isCameraInitialized,
          isInitializing: false,
          controller: _verifyRepo.controller,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isInitializing: false,
            clearError: false,
            hasError: true,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> capturePhoto() async {
    if (!state.isCameraReady || state.hascaptured || isClosed) {
      return;
    }

    try {
      emit(state.copyWith(isprocessing: true));

      final photoPath = await _verifyRepo.capturePhoto();

      if (isClosed) return;

      emit(
        state.copyWith(
          isprocessing: false,
          hascaptured: true,
          capturePhotoPath: photoPath,
        ),
      );

      await verifyFace(selfieImagePath: photoPath);
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isprocessing: false,
            hasError: true,
            errorMessage: 'Failed to capture photo: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> verifyFace({required String selfieImagePath}) async {
    if (isClosed) return;

    emit(state.copyWith(isprocessing: true));

    try {
      final idCardImagePath = await _loadIdCardForVerification.call();

      final result = await _faceVerifyUseCase(
        idCardImagePath: idCardImagePath,
        selfieImagePath: selfieImagePath,
      );

      if (isClosed) return;

      if (result) {
        await _verifyRepo.closeCamera();
        await getIt<OnboardingService>().markVerificationComplete();
        emit(
          state.copyWith(
            isprocessing: false,
            hasError: false,
            isVerificationComplete: true,
            isnotVerified: false,
            isFaceNotMatched: false,
            errorMessage: null,

            clearController: true,
            isOpened: false,
          ),
        );
      }
    } on NoFaceDetectedException catch (e) {
      await _verifyRepo.closeCamera();
      _handleError(e.toString());
    } on MultipleFacesDetectedException catch (e) {
      await _verifyRepo.closeCamera();
      _handleError(e.toString());
    } on LowConfidenceException catch (e) {
      await _verifyRepo.closeCamera();
      _handleError(e.toString());
    } on FaceNotMatchedException catch (e) {
      await _verifyRepo.closeCamera();
      _handleError(
        "Face in the selfie does not match the ID card.${e.toString()}",
        isNotVerified: true,
        isFaceNotMatched: true,
      );
    } catch (e) {
      await _verifyRepo.closeCamera();
      _handleError(e.toString());
    }
  }

  void _handleError(
    String errorMessage, {
    bool isNotVerified = false,
    bool isFaceNotMatched = false,
  }) {
    if (!isClosed) {
      emit(
        state.copyWith(
          isprocessing: false,
          hasError: true,
          isnotVerified: isNotVerified,
          isFaceNotMatched: isFaceNotMatched,
          errorMessage: errorMessage,

          hascaptured: false,
          clearController: true,
          isOpened: false,
        ),
      );
    }
  }

  void retryCapture() {
    if (isClosed) return;

    emit(
      state.copyWith(
        hascaptured: false,
        clearError: true,
        isnotVerified: false,
        isVerificationComplete: false,
        isprocessing: false,
        isFaceNotMatched: false,
      ),
    );

    opencamera();
  }

  @override
  Future<void> close() async {
    await _verifyRepo.closeCamera();
    return super.close();
  }
}
